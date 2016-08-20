About LibreOffice Templates
===========================

I try to look into LibreOffice Templates by reading the XML in ODT files, and I've found something interesting.

I'm using the files in *Designing with LibreOffice* as example, because I'm doing the translation of this book.

Can a template with same name link to the document?
---------------------------------------------------

I've modified the ``designing-with-libreoffice.ott`` file to change the fonts in styles for Chinese. Then I import this template. However, although sometimes Writer will tell me to update the styles when I open a document in the book, very often Writer fails to inform me to update the styles.

So I try to analyze these documents. I've converted the documents to *.fodt* files, so that I can read the XML directly. I can see something like:

```
<meta:template xlink:type="simple" xlink:actuate="onRequest" xlink:title="designing-with-libreoffice" xlink:href="../../../.config/libreoffice/4/user/template/designing-with-libreoffice.ott" meta:date="2016-08-19T15:52:23.301519289"/>
```

So there's a path to the template in it. That's why Writer doesn't always want to update the styles of a document link to a registered template. After I put this document to a level 3 directory relative to **$HOME**, e.g. **~/Documents/DWL/zh**, the auto-update will work, otherwise, for a path with other levels like **~/DWL/zh**, it fails to work.

How style auto-update work
--------------------------

There's such an XML line in the fodt file.

```
<style:style style:name="Labels" style:family="graphic" style:auto-update="true">
```

If you choose to keep the styles when opening a document linking to a template, and save the document, this line will change to ``auto-update="false"``.

In ODT files
------------

For ODT files, they are zipped documents with meta data. For example, I create a /tmp/test.odt with designing-with-libreoffice template, then unzip it.

```
Archive:  ../test.odt
 extracting: mimetype                
 extracting: Thumbnails/thumbnail.png  
  inflating: content.xml             
 extracting: Pictures/100002010000038400000546A82961F87F74FC58.png  
 extracting: Pictures/1000000000000029000000280D79344E3C86B807.png  
 extracting: Pictures/100000000000002700000026E7BA59C467F90D6A.png  
 extracting: Pictures/100002000000000A0000000A35016327E26F24F4.gif  
 extracting: Pictures/100000000000013000000123B3627CCB3F870366.png  
 extracting: Pictures/100000000000014C0000012CA8954B407D4415E6.png  
 extracting: Pictures/100000000000010D000000FF60A0AAE0E228F8E2.png  
  inflating: meta.xml                
  inflating: settings.xml            
   creating: Configurations2/menubar/
   creating: Configurations2/floater/
   creating: Configurations2/images/Bitmaps/
   creating: Configurations2/popupmenu/
   creating: Configurations2/statusbar/
   creating: Configurations2/toolpanel/
   creating: Configurations2/progressbar/
   creating: Configurations2/toolbar/
  inflating: Configurations2/accelerator/current.xml  
  inflating: manifest.rdf            
  inflating: META-INF/manifest.xml   
  inflating: styles.xml
```

The auto-update setting is in styles.xml.

For template, it's stored in meta.xml. However, there's a little strange with the path.

```
xlink:href="../../home/<username>/.config/libreoffice/4/user/template/designing-with-libreoffice.ott"
```

While the file is located in /tmp, there are two *../* in ``xlink:href`` instead of one. If you create an ODT file, you'll see one more *../* in xlink:href than the actual path. That's a difference between ODT and flat ODT. I don't know the exact reason yet.
