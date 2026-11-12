#!/usr/bin/env python3
"""Render marked token JSON into a complete Chinese PDF with embedded subset fonts.

Usage: render-google-guide-pdf.py tokens.json source.md output.pdf --font-cache /tmp/fonts
Requires reportlab and fontTools, plus the freely licensed Noto Sans CJK TTC files.
The source text is included in full. Cover/contents are additional reading aids.
"""
import argparse
import html
import json
from pathlib import Path
import re
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont as RLTTFont
from reportlab.platypus import (SimpleDocTemplate, Paragraph, Spacer, PageBreak,
    Table, TableStyle, KeepTogether, HRFlowable)
from fontTools.ttLib import TTFont
from fontTools import subset
from fontTools.fontBuilder import FontBuilder
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.pens.cu2quPen import Cu2QuPen

P=argparse.ArgumentParser(description=__doc__)
P.add_argument('tokens',type=Path);P.add_argument('source',type=Path);P.add_argument('output',type=Path)
P.add_argument('--font-cache',type=Path,required=True)
A=P.parse_args();A.font_cache.mkdir(parents=True,exist_ok=True)
tokens=json.loads(A.tokens.read_text());source=A.source.read_text()
extra='CP Google 導航完整設定教學從申請到開始使用與連接 CoPilot tw目錄版本核對日期本人帳戶金鑰服務計費本次簽章已核對尚待裝置驗收步驟付款導航搜尋道路等000123456789•☐×→／：abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
chars=source+extra+Path(__file__).read_text()

def font(name,weight):
    dest=A.font_cache/(name+'.ttf')
    original=Path('/usr/share/fonts/opentype/noto/NotoSansCJK-'+weight+'.ttc')
    f=TTFont(original,fontNumber=3)
    opts=subset.Options();opts.retain_gids=False
    s=subset.Subsetter(options=opts);s.populate(text=chars);s.subset(f)
    order=f.getGlyphOrder();glyphset=f.getGlyphSet();glyphs={}
    for n in order:
        pen=TTGlyphPen(None);glyphset[n].draw(Cu2QuPen(pen,max_err=1.0,reverse_direction=True));glyphs[n]=pen.glyph()
    b=FontBuilder(f['head'].unitsPerEm,isTTF=True)
    b.setupGlyphOrder(order);b.setupCharacterMap(f.getBestCmap());b.setupGlyf(glyphs)
    b.setupHorizontalMetrics({n:f['hmtx'].metrics[n] for n in order})
    b.setupHorizontalHeader(ascent=f['hhea'].ascent,descent=f['hhea'].descent)
    b.setupOS2(sTypoAscender=f['OS/2'].sTypoAscender,sTypoDescender=f['OS/2'].sTypoDescender,
               usWinAscent=f['OS/2'].usWinAscent,usWinDescent=f['OS/2'].usWinDescent)
    b.setupNameTable({'familyName':name,'styleName':'Regular','uniqueFontIdentifier':name+'-subset',
                     'fullName':name,'psName':name,'version':'Version 1.0'})
    b.setupPost();b.save(dest)
    pdfmetrics.registerFont(RLTTFont(name,str(dest)))

font('GuideTC','Regular');font('GuideTCBold','Bold')
pdfmetrics.registerFontFamily('GuideTC',normal='GuideTC',bold='GuideTCBold',italic='GuideTC',boldItalic='GuideTCBold')
NAVY=colors.HexColor('#152e46');BLUE=colors.HexColor('#14618e');TEAL=colors.HexColor('#087f80')
INK=colors.HexColor('#20384c');MUTED=colors.HexColor('#566b7c');LINE=colors.HexColor('#d7e3eb');TINT=colors.HexColor('#eff6fa')
W,H=A4;M=48;WIDTH=W-2*M
base=dict(fontName='GuideTC',textColor=INK,wordWrap='CJK',splitLongWords=1,allowWidows=0,allowOrphans=0)
styles={
 'body':ParagraphStyle('Body',fontSize=10.2,leading=16.6,spaceAfter=8,**base),
 'h2':ParagraphStyle('Heading2',fontSize=19,leading=29,spaceAfter=17,keepWithNext=True,**{**base,'fontName':'GuideTCBold','textColor':NAVY}),
 'h3':ParagraphStyle('Heading3',fontSize=12.5,leading=21,spaceBefore=12,spaceAfter=8,keepWithNext=True,**{**base,'fontName':'GuideTCBold','textColor':BLUE}),
 'table':ParagraphStyle('Table',fontSize=8.7,leading=14.5,spaceAfter=0,**base),
 'th':ParagraphStyle('TableHeader',fontSize=9.1,leading=15,spaceAfter=0,**{**base,'fontName':'GuideTCBold','textColor':colors.white}),
 'code':ParagraphStyle('Code',fontSize=8.5,leading=14.2,spaceBefore=6,spaceAfter=10,backColor=TINT,borderPadding=10,**base),
 'toc':ParagraphStyle('Contents',fontSize=11,leading=20,spaceAfter=6,**base),
 'cover':ParagraphStyle('Cover',fontSize=34,leading=49,spaceAfter=22,**{**base,'fontName':'GuideTCBold','textColor':NAVY}),
 'sub':ParagraphStyle('Subtitle',fontSize=18,leading=30,spaceAfter=24,**{**base,'textColor':MUTED}),
 'small':ParagraphStyle('Small',fontSize=9.2,leading=15.7,spaceAfter=8,**{**base,'textColor':MUTED}),
 'tag':ParagraphStyle('Tag',fontSize=11,leading=19,spaceAfter=10,**{**base,'fontName':'GuideTCBold','textColor':TEAL}),
}
def esc(s):return html.escape(html.unescape(s),quote=False)
def inline(ts):
    out=[]
    for t in ts or []:
        ty=t['type'];text=t.get('text','')
        child=inline(t.get('tokens')) if t.get('tokens') else esc(text)
        if ty=='strong':out.append('<b>'+child+'</b>')
        elif ty=='em':out.append('<i>'+child+'</i>')
        elif ty=='codespan':out.append('<font color="#155b87">'+esc(text)+'</font>')
        elif ty=='link':out.append('<link href="'+html.escape(t['href'],quote=True)+'" color="#14618e">'+child+'</link>')
        elif ty=='br':out.append('<br/>')
        elif ty=='escape':out.append(esc(text))
        elif ty=='html':out.append(esc(re.sub('<[^>]+>','',text)))
        else:out.append(child)
    return ''.join(out)
def para(t,style='body'):return Paragraph(inline(t.get('tokens')) or esc(t.get('text','')),styles[style])
story=[]
story += [Spacer(1,24),Paragraph('COPILOT TW / SETUP GUIDE',styles['tag']),Spacer(1,35),
          Paragraph('CP Google 導航<br/>完整設定教學',styles['cover']),
          Paragraph('從申請 Google Cloud、設定 API 金鑰，<br/>到開始導航及連接 CoPilot tw。',styles['sub']),
          Paragraph('CP Google 0.1.1 × CoPilot tw wide.46',styles['tag']),Spacer(1,36)]
covercards=Table([[Paragraph('<b>照步驟完成設定</b><br/>帳戶與計費、兩個必要 API、套件名稱、SHA-1、API 限制與 App 操作。',styles['body']),
                   Paragraph('<b>知道怎樣確認成功</b><br/>搜尋、導航、CoPilot 讀取與 C4 接收分層確認；附費用控制與常見錯誤。',styles['body'])]],colWidths=[WIDTH/2]*2)
covercards.setStyle(TableStyle([('VALIGN',(0,0),(-1,-1),'TOP'),('LINEABOVE',(0,0),(-1,-1),1.5,LINE),('TOPPADDING',(0,0),(-1,-1),15),('LEFTPADDING',(0,0),(-1,-1),0),('RIGHTPADDING',(0,0),(-1,-1),18)]))
story += [covercards,Spacer(1,29),Paragraph('<b>先記住：</b>Google Navigation SDK 有每月免費用量，但仍須啟用計費。搜尋目的地的 Places API 另行計算。本配套沒有內附共用金鑰。',styles['code']),Spacer(1,14),Paragraph('文件與官方資料核對：2026-11-12<br/>本次 0.1.1 APK 簽章已核對；真實 Google 授權、帳單與 C4 接收由裝置驗收確認。',styles['small']),PageBreak()]
headings=[t for t in tokens if t['type']=='heading' and t['depth']==2 and not t['text'].startswith('從申請')]
story.append(Paragraph('教學目錄',styles['h2']))
for i,t in enumerate(headings):story.append(Paragraph(f'<link href="#sec{i}" color="#14618e">{esc(t["text"])}</link>',styles['toc']))
story.append(PageBreak())
heading_no=0;first_content=True
def blocks(ts,indent=0):
    global heading_no,first_content
    result=[]
    for t in ts:
        ty=t['type']
        if ty=='heading':
            d=t['depth']
            if d==1 or (d==2 and t['text'].startswith('從申請')):continue
            if d==2:
                major=t['text'].startswith(('2. ','8. ','官方資料'))
                if not first_content:result.append(PageBreak() if major else Spacer(1,16))
                first_content=False
                result.append(Paragraph(f'<a name="sec{heading_no}"/>'+inline(t['tokens']),styles['h2']));heading_no+=1
            else:result.append(para(t,'h3'))
        elif ty in ('paragraph','text'):
            first_content=False
            result.append(para(t))
        elif ty=='list':
            start=t.get('start',1) if t.get('ordered') else None
            for j,item in enumerate(t['items']):
                prefix=f'{int(start)+j}.' if start is not None else ('[ ]' if item.get('task') else '•')
                sub=blocks(item['tokens'],indent+1)
                if not sub:continue
                listtable=Table([[Paragraph(prefix,styles['body']),sub]],colWidths=[21,WIDTH-21-indent*10])
                listtable.setStyle(TableStyle([('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),0),('RIGHTPADDING',(0,0),(-1,-1),0),('TOPPADDING',(0,0),(-1,-1),0),('BOTTOMPADDING',(0,0),(-1,-1),0)]))
                result.append(listtable)
        elif ty=='table':
            cells=[t['header']]+t['rows'];n=len(t['header'])
            widths={2:[.30,.70],3:[.25,.35,.40],4:[.30,.22,.23,.25]}.get(n,[1/n]*n)
            if t['header'][0]['text']=='編號':widths=[.08,.50,.42]
            if t['header'][0]['text']=='訊息／錯誤碼':widths=[.27,.23,.50]
            rows=[[Paragraph(inline(c.get('tokens')) or esc(c.get('text','')),styles['th' if r==0 else 'table']) for c in row] for r,row in enumerate(cells)]
            tab=Table(rows,colWidths=[WIDTH*f for f in widths],repeatRows=1,hAlign='LEFT')
            tab.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),NAVY),('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.white,colors.HexColor('#f4f8fb')]),('GRID',(0,0),(-1,-1),.45,LINE),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),8),('RIGHTPADDING',(0,0),(-1,-1),8),('TOPPADDING',(0,0),(-1,-1),8),('BOTTOMPADDING',(0,0),(-1,-1),8)]))
            tab.spaceBefore=5;tab.spaceAfter=12
            result.append(tab)
        elif ty=='code':result.append(Paragraph(esc(t['text']).replace('\n','<br/>'),styles['code']))
        elif ty=='hr':result.append(HRFlowable(width='100%',thickness=.6,color=LINE,spaceBefore=12,spaceAfter=12))
        elif ty=='blockquote':result+=blocks(t['tokens'],indent)
        elif ty in ('space','def','checkbox'):continue
        else:raise ValueError('Unhandled markdown token '+ty)
    return result
story+=blocks(tokens)
def page(c,doc):
    c.saveState();c.setStrokeColor(LINE);c.setLineWidth(.5);c.line(M,H-32,W-M,H-32)
    c.setFont('GuideTC',7.3);c.setFillColor(MUTED)
    c.drawString(M,H-24,'COPILOT TW / CP GOOGLE NAVIGATION')
    c.drawRightString(W-M,H-24,'完整設定教學 · 2026-11-12')
    c.line(M,34,W-M,34);c.drawString(M,22,'CP Google 0.1.1 × CoPilot tw wide.46')
    c.drawRightString(W-M,22,str(doc.page));c.restoreState()
A.output.parent.mkdir(parents=True,exist_ok=True)
doc=SimpleDocTemplate(str(A.output),pagesize=A4,rightMargin=M,leftMargin=M,topMargin=48,bottomMargin=49,
                      title='CP Google 導航完整設定教學',author='CoPilot tw',subject='0.1.1 / wide.46 · Google Cloud 申請、設定、使用及排錯')
doc.build(story,onFirstPage=page,onLaterPages=page)
print(json.dumps({'pdf':str(A.output),'sections':heading_no,'bytes':A.output.stat().st_size},ensure_ascii=False))
