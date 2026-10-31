#!/usr/bin/env python3
"""Bounded public news, transcript and X web-page quote collection."""
from concurrent.futures import ThreadPoolExecutor
import datetime as dt
from email.utils import parsedate_to_datetime
import hashlib
from html.parser import HTMLParser
import re
from urllib.error import HTTPError
from urllib.parse import urlsplit
from urllib.request import Request, build_opener, HTTPRedirectHandler
import xml.etree.ElementTree as ET

NEWS = {
    'guardian': ('https://www.theguardian.com/us-news/donaldtrump/rss', 'www.theguardian.com'),
    'pbs': ('https://www.pbs.org/newshour/feeds/rss/politics', 'www.pbs.org'),
}
SITEMAP = 'https://rollcall.com/factbase-trump-transcripts-1-sitemap.xml'
HOSTS = {'www.theguardian.com', 'www.pbs.org', 'rollcall.com', 'x.com'}
SIGNAL = re.compile(r'\b(ass|asses|piggy|loser|stupid|idiot|dumb|crooked|disgusting|crazy|lunatic|moron|ugly|fat|greatest|smartest|tremendous|witch hunt|out of shape|look like hell|sick)\b', re.I)
MONTHS = {name.lower(): i for i, name in enumerate(
    ['January','February','March','April','May','June','July','August','September','October','November','December'], 1)}


def allowed_url(url):
    parsed = urlsplit(url)
    return (parsed.scheme == 'https' and parsed.hostname in HOSTS and not parsed.username
            and not parsed.password and parsed.port in (None, 443))


class SafeRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        if not allowed_url(newurl):
            raise ValueError('Refused redirect outside the permitted public source')
        return super().redirect_request(req, fp, code, msg, headers, newurl)


def fetch(url):
    if not allowed_url(url):
        raise ValueError('Source URL is not permitted')
    headers = {'User-Agent': 'TrumpQuotesForever public quote collector'}
    try:
        with build_opener(SafeRedirect).open(Request(url, headers=headers), timeout=15) as response:
            data = response.read(8_000_001)
        if len(data) > 8_000_000:
            raise ValueError('Source exceeds size limit')
        return data.decode('utf-8', errors='replace')
    except HTTPError as error:
        raise ValueError(f'Source HTTP {error.code}') from None


def recent(date, now):
    return date.tzinfo is not None and now - dt.timedelta(days=7) <= date <= now


def rank(text):
    strong = len(re.findall(r'\b(ass|asses|piggy|loser|stupid|idiot|dumb|crooked|disgusting|crazy|lunatic|moron|ugly|fat|witch hunt|out of shape|look like hell)\b', text, re.I))
    return strong * 5 + len(SIGNAL.findall(text))


def excerpt(text):
    """One exact short quote or a complete sentence inside a longer speech turn."""
    text = re.sub(r'\s+', ' ', text).strip()
    if re.search(r'\b(endorse(?:ment)?|vote for|donate|reposted)\b', text, re.I):
        return None
    chunks = [text] if len(text.split()) <= 25 else re.findall(r'(?:^|(?<=[.!?])\s)([^.!?]+[.!?])(?=\s|$)', text)
    valid = [s.strip() for s in chunks if 3 <= len(s.split()) <= 25 and SIGNAL.search(s)
             and not re.search(r'["“”\[\]|\x00-\x1f\x7f]', s)]
    valid = [s for s in valid if len(('"' + s + '" - Donald Trump').encode()) <= 255]
    return max(valid,key=rank) if valid else None


def record(quote, source, date, kind, now, context, evidence=None):
    return {'id': 'public-' + hashlib.sha256(source.encode()).hexdigest()[:20],
            'quote': quote, 'date': date.date().isoformat(), 'source_url': source,
            'evidence_url': evidence or source, 'source_kind': kind,
            'context': context + ' Source matching is not independent authentication or fact checking. '
                       'Automatic quote-only acceptance was authorized by the maintainer.',
            'assessment': 'unverified-claim', 'checked_at': now.isoformat(), 'attribution': 'source-matched'}


class Page(HTMLParser):
    """Read only article paragraphs and explicitly labeled transcript turns."""
    VOID = {'area','base','br','col','embed','hr','img','input','link','meta','param','source','track','wbr'}

    def __init__(self, source):
        super().__init__(convert_charrefs=True)
        self.source, self.stack = source, []
        self.article_depth = None
        self.capture = None
        self.paragraphs, self.turns, self.links = [], [], []
        self.speaker = ''
        self.speaker_depth = None
        self.speaker_text = []
        self.segment = False
        self.tweet = None
        self.tweets = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        depth = len(self.stack)
        classes = attrs.get('class', '').split()
        if tag == 'a' and attrs.get('href'):
            self.links.append(attrs['href'])
            if self.tweet is not None:
                self.tweet['links'].append(attrs['href'])
        if self.source == 'guardian' and attrs.get('data-gu-name') == 'body':
            self.article_depth = depth
        if self.source == 'pbs' and (tag == 'article' or 'body-text' in classes):
            if self.article_depth is None:
                self.article_depth = depth
        if self.source == 'rollcall' and tag == 'div' and re.match(r'^dt\d.*-\d+$', attrs.get('id', '')):
            self.segment, self.speaker = True, ''
        if self.source == 'rollcall' and self.segment and tag == 'h2':
            self.speaker_depth, self.speaker_text = depth, []
        if self.capture is None:
            if tag == 'p' and self.article_depth is not None:
                self.capture = (depth, 'paragraph', [])
            elif self.source == 'rollcall' and tag == 'div' and 'leading-loose' in classes and self.segment:
                self.capture = (depth, 'turn' if self.speaker == 'Donald Trump' else 'ignore', [])
        if tag == 'blockquote' and 'twitter-tweet' in classes:
            self.tweet = {'depth': depth, 'body': [], 'footer': [], 'links': [], 'p_depth': None}
        if self.tweet is not None and tag == 'p':
            self.tweet['p_depth'] = depth
        if tag == 'br' and self.capture:
            self.capture[2].append(' ')
        if tag not in self.VOID:
            self.stack.append(tag)

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        if tag not in self.VOID:
            self.handle_endtag(tag)

    def handle_data(self, text):
        if any(tag in {'script','style','noscript'} for tag in self.stack):
            return
        if self.speaker_depth is not None:
            self.speaker_text.append(text)
        if self.capture:
            self.capture[2].append(text)
        if self.tweet is not None:
            self.tweet['body' if self.tweet['p_depth'] is not None else 'footer'].append(text)

    def handle_endtag(self, tag):
        if tag not in self.stack:
            return
        index = len(self.stack) - 1 - self.stack[::-1].index(tag)
        if self.speaker_depth is not None and index <= self.speaker_depth:
            self.speaker = ''.join(self.speaker_text).strip()
            self.speaker_depth = None
        if self.capture and index <= self.capture[0]:
            text = re.sub(r'\s+', ' ', ''.join(self.capture[2])).strip()
            if self.capture[1] == 'paragraph':
                self.paragraphs.append(text)
            elif self.capture[1] == 'turn':
                self.turns.append(text)
            self.capture = None
        if self.article_depth is not None and index <= self.article_depth:
            self.article_depth = None
        if self.tweet is not None:
            if tag == 'p':
                self.tweet['p_depth'] = None
            if index <= self.tweet['depth']:
                self.tweets.append(self.tweet)
                self.tweet = None
        del self.stack[index:]


TRUMP = r'(?:Donald(?: J\.)? Trump|President (?:Donald )?Trump|Trump)'
VERB = r'(?:said|wrote|posted|added|claimed|joked|shouted|asked)'
QUOTED = r'(?:“([^“”]+)”|"([^"\n]+)")'
BEFORE = re.compile(TRUMP + r'\s+' + VERB + r'(?:\s+on\s+(?:X|Twitter|Truth Social))?\s*[:,]\s*' + QUOTED)
AFTER = re.compile(QUOTED + r'\s*,?\s*(?:' + TRUMP + r'\s+' + VERB + r'|' + VERB + r'\s+' + TRUMP + r')\b')


def news_candidates(html, source, url, published, now):
    page = Page(source)
    page.feed(html)
    if not page.paragraphs:
        raise ValueError('No accessible article body; do not treat this as a checked article with no quotes')
    found = []
    for paragraph in page.paragraphs:
        # Avoid retrospective quotations, speculative/negated attributions and
        # named relatives, whose surname also is Trump.
        if re.search(r'\b(?:would|might|could|never|did not|didn.t)\s+(?:say|said|write)|\b(?:Eric|Lara|Melania|Ivanka|Donald Trump Jr\.)\b', paragraph, re.I):
            continue
        years = re.findall(r'\b(?:in|during) (20\d\d)\b', paragraph)
        if any(int(year) != published.year for year in years):
            continue
        for pattern in (BEFORE, AFTER):
            for match in pattern.finditer(paragraph):
                quote = excerpt(next(g for g in match.groups() if g is not None))
                if quote:
                    found.append(record(quote, url, published, 'news_report', now,
                        'Direct quotation explicitly attributed to Donald Trump in a publisher article paragraph. '
                        'The record date is article publication, not a verified time of utterance; other article context is omitted.'))
    # An embedded original X post is attributable only when its footer names the
    # official account AND provides that account's original status URL.
    tweets = []
    for embed in page.tweets:
        footer = ''.join(embed['footer'])
        if not re.search(r'\(@realDonaldTrump\)', footer, re.I):
            continue
        links = [link for link in embed['links'] if re.fullmatch(r'https://(?:twitter|x)\.com/realDonaldTrump/status/\d+(?:\?.*)?', link)]
        if len(links) != 1:
            continue
        identity = re.search(r'/status/(\d+)', links[0])[1]
        timestamp = dt.datetime.fromtimestamp(((int(identity) >> 22) + 1288834974657) / 1000, dt.timezone.utc)
        quote = excerpt(''.join(embed['body']))
        if quote and recent(timestamp, now):
            tweets.append(record(quote, links[0].split('?')[0], timestamp, 'account_post', now,
                'Original X/Twitter post embedded in an accessible news article. Official account attribution and status link '
                'were read from the embed footer; creation time is decoded from the status Snowflake ID. '
                'This is not a direct timeline fetch.', evidence=url))
    return sorted(found,key=lambda r:rank(r['quote']),reverse=True)[:5], tweets[:1], page.links


def transcript_date(url):
    match = re.search(r'-([a-z]+)-(\d{1,2})-(20\d\d)/?$', url)
    if not match or match[1] not in MONTHS:
        return None
    try:
        return dt.datetime(int(match[3]), MONTHS[match[1]], int(match[2]), tzinfo=dt.timezone.utc)
    except ValueError:
        return None


def transcript_candidate(html, url, now):
    date = transcript_date(url)
    if not date or not recent(date, now):
        return []
    page = Page('rollcall')
    page.feed(html)
    results = []
    for turn in page.turns:
        quote = excerpt(turn)
        if quote:
            kind = 'press_exchange' if 'press-gaggle' in url else 'interview' if 'interview' in url else 'speech'
            results.append(record(quote, url, date, kind, now,
                'Contiguous excerpt from a Roll Call Factba.se transcript turn explicitly labeled Donald Trump. '
                'Other speakers and transcript metadata are excluded; other remarks in the turn are omitted.'))
    return sorted(results,key=lambda r:rank(r['quote']),reverse=True)[:5]


class XProfile(HTMLParser):
    """Parse visible post markup only, never script state or private endpoints."""
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.stack, self.current, self.posts = [], None, []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        depth = len(self.stack)
        if tag == 'article':
            if self.current is None:
                self.current = {'depth':depth,'author':None,'links':[], 'body':[],
                                'text_depth':None,'quoted':False,'truncated':False,'context':[]}
            else:
                self.current['quoted'] = True
        if self.current is not None:
            href = attrs.get('href','')
            if tag == 'a':
                if self.current['author'] is None and re.fullmatch(r'/[A-Za-z0-9_]{1,15}',href):
                    self.current['author'] = href[1:]
                if re.fullmatch(r'/realDonaldTrump/status/\d+',href,re.I):
                    self.current['links'].append('https://x.com'+href)
            classes = attrs.get('class','').split()
            if self.current['text_depth'] is None and (attrs.get('data-testid')=='tweetText' or
                    (attrs.get('dir')=='auto' and 'whitespace-pre-wrap' in classes)):
                self.current['text_depth'] = depth
            if attrs.get('data-testid') == 'socialContext':
                self.current['quoted'] = True  # Repost context; do not attribute it to Trump.
        if tag not in Page.VOID:
            self.stack.append(tag)

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag,attrs)
        if tag not in Page.VOID:
            self.handle_endtag(tag)

    def handle_data(self,text):
        if self.current is None or any(t in {'script','style','noscript'} for t in self.stack):
            return
        if 'button' in self.stack:
            if text.strip().lower()=='show more':
                self.current['truncated']=True
            return
        if self.current['text_depth'] is not None:
            self.current['body'].append(text)

    def handle_endtag(self,tag):
        if tag not in self.stack:
            return
        index=len(self.stack)-1-self.stack[::-1].index(tag)
        if self.current is not None:
            if self.current['text_depth'] is not None and index<=self.current['text_depth']:
                self.current['text_depth']=None
            if index<=self.current['depth']:
                self.posts.append(self.current)
                self.current=None
        del self.stack[index:]


def x_web_candidates(html, now):
    profile=XProfile()
    profile.feed(html)
    if not profile.posts:
        raise ValueError('No readable public X posts; login/access wall or markup change')
    results=[]
    for post in profile.posts[:30]:
        if post['author'] is None or post['author'].lower()!='realdonaldtrump' or post['quoted'] or post['truncated']:
            continue
        links=list(dict.fromkeys(post['links']))
        if len(links)!=1:
            continue
        identity=links[0].rsplit('/',1)[1]
        published=dt.datetime.fromtimestamp(((int(identity)>>22)+1288834974657)/1000,dt.timezone.utc)
        quote=excerpt(''.join(post['body']))
        if quote and recent(published,now) and not re.search(r'https?://|\bRT @',quote):
            results.append(record(quote,links[0],published,'account_post',now,
                'Exact text scraped from visible article markup on the public realDonaldTrump X profile. '
                'The post author, original status link and Snowflake creation date were checked. '
                'Reposts, nested quote-posts and truncated Show more text are excluded. '
                'Only the accessible guest view was inspected; no login or paid API was used.'))
    return results, {'status':'checked','posts_checked':min(len(profile.posts),30),
                     'truncated_posts':sum(p['truncated'] for p in profile.posts[:30]),
                     'limited_public_view':True,'attributed_candidates':len(results)}


def collect(now, known_sources=()):
    news, transcripts, social, coverage = [], [], [], {}
    known = set(known_sources)
    for source, (feed_url, host) in NEWS.items():
        try:
            feed = ET.fromstring(fetch(feed_url))
            items = feed.findall('./channel/item')
            if not items:
                raise ValueError('No RSS items')
            articles = []
            for item in items:
                url, title = item.findtext('link',''), item.findtext('title','')
                if urlsplit(url).hostname != host or not allowed_url(url) or url.rstrip('/') in known:
                    continue
                try:
                    date = parsedate_to_datetime(item.findtext('pubDate',''))
                except (ValueError, TypeError):
                    continue
                if not recent(date, now) or re.search(r'live|opinion|analysis|letters|cartoon', title, re.I):
                    continue
                if 'trump' not in (title + ' ' + item.findtext('description','')).lower():
                    continue
                articles.append((url, date))
            def read_article(item):
                url, published = item
                try:
                    return news_candidates(fetch(url), source, url, published, now), None
                except Exception as error:
                    return None, type(error).__name__
            with ThreadPoolExecutor(max_workers=4) as pool:
                results = list(pool.map(read_article, articles[:10]))
            failures = 0
            for result, error in results:
                if error:
                    failures += 1
                else:
                    quotes, tweets, _ = result
                    news.extend(quotes)
                    social.extend(tweets)
            coverage[source] = {'status':'checked', 'articles_checked':len(results)-failures,
                                'article_failures':failures, 'attributed_candidates':sum(len(r[0][0])+len(r[0][1]) for r in results if r[0])}
        except Exception as error:
            coverage[source] = {'status':'unavailable','reason':type(error).__name__}
    try:
        root = ET.fromstring(fetch(SITEMAP))
        urls = [node.text for node in root.iter() if node.tag.endswith('}loc') and node.text]
        urls = [url for url in urls if urlsplit(url).hostname == 'rollcall.com'
                and '/factbase/trump/transcript/' in url and url.rstrip('/') not in known
                and transcript_date(url) and recent(transcript_date(url), now)]
        urls.sort(key=lambda u:(transcript_date(u), 'press-gaggle' in u or 'interview' in u), reverse=True)
        def read_transcript(url):
            try:
                return transcript_candidate(fetch(url), url, now), None
            except Exception as error:
                return [], type(error).__name__
        with ThreadPoolExecutor(max_workers=4) as pool:
            results = list(pool.map(read_transcript, urls[:24]))
        for quotes, error in results:
            transcripts.extend(quotes)
        coverage['rollcall_transcripts'] = {'status':'checked','transcripts_checked':sum(error is None for _,error in results),
                                            'failures':sum(error is not None for _,error in results),'attributed_candidates':len(transcripts)}
    except Exception as error:
        coverage['rollcall_transcripts'] = {'status':'unavailable','reason':type(error).__name__}
    try:
        direct, coverage['x_public_profile'] = x_web_candidates(fetch('https://x.com/realDonaldTrump'),now)
        social.extend(direct)
    except Exception as error:
        coverage['x_public_profile']={'status':'unavailable','reason':type(error).__name__,
                                     'detail':'Public page inaccessible or markup changed; no paid API or access-control bypass is used'}
    transcripts.sort(key=lambda r:rank(r['quote']),reverse=True)
    news.sort(key=lambda r:rank(r['quote']),reverse=True)
    social.sort(key=lambda r:rank(r['quote']),reverse=True)
    return [transcripts, news, social], coverage
