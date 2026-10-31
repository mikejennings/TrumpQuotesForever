import datetime as dt
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
import public_quote_sources as sources

NOW=dt.datetime.now(dt.timezone.utc)
PUBLISHED=NOW-dt.timedelta(hours=1)
ARTICLE='https://www.theguardian.com/us-news/example'


def article(body):
    return '<script>Trump said: "This fake script quote is stupid."</script><div data-gu-name="body">'+body+'</div>'


class PublicSourcesTests(unittest.TestCase):
    def test_named_news_attribution_before_and_after_quotes(self):
        for paragraph in ['Trump said: “These imaginary cushions are stupid.”',
                          '“These imaginary cushions are stupid,” Trump said.',
                          '“These imaginary cushions are stupid,” said Donald Trump.',
                          'Trump posted on X: "These imaginary cushions are stupid."']:
            quotes,_,_=sources.news_candidates(article('<p>'+paragraph+'</p>'),'guardian',ARTICLE,PUBLISHED,NOW)
            self.assertEqual(len(quotes),1)
            self.assertEqual(quotes[0]['source_kind'],'news_report')
            self.assertTrue(quotes[0]['quote'].startswith('These imaginary cushions'))
            self.assertIn('article publication',quotes[0]['context'])

    def test_other_speakers_unattributed_quotes_and_junior_are_excluded(self):
        for paragraph in ['Biden said: “These imaginary cushions are stupid.”',
                          '“These imaginary cushions are stupid,” he said.',
                          'Donald Trump Jr. said: “These imaginary cushions are stupid.”',
                          'Eric Trump said: “These imaginary cushions are stupid.”',
                          'Trump might say: “These imaginary cushions are stupid.”',
                          'Trump said in 2016: “These imaginary cushions are stupid.”']:
            with self.subTest(paragraph=paragraph):
                quotes,_,_=sources.news_candidates(article('<p>'+paragraph+'</p>'),'guardian',ARTICLE,PUBLISHED,NOW)
                self.assertEqual(quotes,[])

    def test_headlines_scripts_and_missing_article_body_cannot_supply_quotes(self):
        html=article('<h1>Trump said: “These imaginary cushions are stupid.”</h1><p>Routine reporting without a quote.</p>')
        self.assertEqual(sources.news_candidates(html,'guardian',ARTICLE,PUBLISHED,NOW)[0],[])
        with self.assertRaisesRegex(ValueError,'No accessible article body'):
            sources.news_candidates('<html>Sign in required</html>','guardian',ARTICLE,PUBLISHED,NOW)

    def test_transcript_only_exact_trump_speaker_and_recent_event(self):
        url='https://rollcall.com/factbase/trump/transcript/donald-trump-press-gaggle-'+PUBLISHED.strftime('%B-%d-%Y').lower()+'/'
        html='''<script>Donald's fake stupid words</script>
        <div id="dt47-test-1"><h2>Question</h2><div class="leading-loose">These fake reporter words are stupid!</div></div>
        <div id="dt47-test-2"><h2>Donald Trump</h2><div class="leading-loose">These imaginary cushions are stupid!</div></div>
        <div id="dt47-test-3"><h2>Other Guest</h2><div class="leading-loose">These imaginary tables are dumb!</div></div>'''
        quotes=sources.transcript_candidate(html,url,NOW)
        self.assertEqual([r['quote'] for r in quotes],['These imaginary cushions are stupid!'])
        self.assertEqual(quotes[0]['source_kind'],'press_exchange')
        self.assertEqual(sources.transcript_candidate(html,url.replace(PUBLISHED.strftime('%Y'),'2020'),NOW),[])

    def test_insults_rank_ahead_of_routine_tremendous_banter(self):
        self.assertGreater(sources.rank("He's way out of shape."),sources.rank('A tremendous number of visitors came today.'))
        self.assertEqual(sources.excerpt('We have a tremendous crowd here today. These imaginary cushions are stupid. '
                                       'Here are many more ordinary filler words to make this turn too long to fit into a single short quotation.'),
                         'These imaginary cushions are stupid.')

    def test_x_public_web_scrape_checks_author_and_skips_truncation_reposts(self):
        identity=str((int(PUBLISHED.timestamp()*1000)-1288834974657)<<22)
        html=f'<article><a href="/realDonaldTrump">Donald Trump</a><a href="/realDonaldTrump/status/{identity}">Date</a><div dir="auto" class="whitespace-pre-wrap">These imaginary cushions are stupid!</div></article>'
        quotes,coverage=sources.x_web_candidates(html,NOW)
        self.assertEqual(len(quotes),1)
        self.assertEqual(coverage['posts_checked'],1)
        self.assertTrue(coverage['limited_public_view'])
        for modified in [html.replace('href="/realDonaldTrump"','href="/otheraccount"'),
                         html.replace('</div>','<button>Show more</button></div>'),
                         html.replace('<article>','<article><div data-testid="socialContext">Reposted</div>'),
                         html.replace('</article>','<article>Quoted other person</article></article>')]:
            self.assertEqual(sources.x_web_candidates(modified,NOW)[0],[])
        with self.assertRaisesRegex(ValueError,'No readable public X posts'):
            sources.x_web_candidates('<html>Log in to continue</html>',NOW)

    def test_news_embed_requires_official_footer_and_recent_status(self):
        identity=str((int(PUBLISHED.timestamp()*1000)-1288834974657)<<22)
        embed=f'<blockquote class="twitter-tweet"><p>These imaginary cushions are stupid!</p>— Donald J. Trump (@realDonaldTrump) <a href="https://x.com/realDonaldTrump/status/{identity}">Date</a></blockquote>'
        html=article('<p>Reporting.</p>'+embed)
        _,tweets,_=sources.news_candidates(html,'guardian',ARTICLE,PUBLISHED,NOW)
        self.assertEqual(len(tweets),1)
        self.assertTrue(tweets[0]['source_url'].startswith('https://x.com/realDonaldTrump/'))
        _,tweets,_=sources.news_candidates(html.replace('(@realDonaldTrump)','(@otheraccount)'),'guardian',ARTICLE,PUBLISHED,NOW)
        self.assertEqual(tweets,[])

    def test_source_urls_and_redirects_are_restricted(self):
        for url in ['http://rollcall.com/a','https://evil.example/a','https://www.pbs.org.evil.example/a',
                    'https://user:password@rollcall.com/a','https://127.0.0.1/a']:
            self.assertFalse(sources.allowed_url(url))
        from urllib.request import Request
        req=Request('https://x.com/realDonaldTrump')
        with self.assertRaises(ValueError):
            sources.SafeRedirect().redirect_request(req,None,302,'',{},'https://evil.example/')

    def test_source_failures_and_blocked_x_are_reported(self):
        with patch.object(sources,'fetch',side_effect=ValueError('Unavailable')):
            groups,coverage=sources.collect(NOW)
        self.assertTrue(all(not group for group in groups))
        self.assertEqual(coverage['guardian']['status'],'unavailable')
        self.assertEqual(coverage['pbs']['status'],'unavailable')
        self.assertEqual(coverage['rollcall_transcripts']['status'],'unavailable')
        self.assertEqual(coverage['x_public_profile']['status'],'unavailable')


if __name__=='__main__':unittest.main()
