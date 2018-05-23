import xml.etree.ElementTree

x="""<foo><bar><type foobar="1"/type><type foobar="2"/type></bar></foo>"""

e = xml.etree.ElementTree.parse('XML_File_01.xml').getroot()
for atype in e.findall('type'):
    print(atype.get('foobar'))

print ('End 1')

from xml.dom import minidom
xmldoc = minidom.parse('items.xml')

itemlist = xmldoc.getElementsByTagName('item')

print(len(itemlist))
print(itemlist[0].attributes['name'].value)

print ('End 2')

for s in itemlist:
    print(s.attributes['name'].value)

print ('End 3')
