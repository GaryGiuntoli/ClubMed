import xml.etree.cElementTree as ET
 
#----------------------------------------------------------------------
def parseXML(xml_file):
    """
    Parse XML with ElementTree
    """
    tree = ET.ElementTree(file=xml_file)
    print (tree.getroot())
    root = tree.getroot()
    print ("tag=%s, attrib=%s" % (root.tag, root.attrib))
 
    for child in root:
        print (child.tag, child.attrib)
        if child.tag == "appointment":
            for step_child in child:
                if step_child.tag == "comments":
                    print (step_child.tag, step_child.attrib)
                else:
                    print (step_child.tag)
 
    # iterate over the entire tree
    print ("-" * 40)
    print ("Iterating using a tree iterator")
    print ("-" * 40)
    iter_ = tree.getiterator()
    for elem in iter_:
        print (elem.tag)
 
    # get the information via the children!
    print ("-" * 40)
    print ("Iterating using getchildren()")
    print ("-" * 40)
    appointments = root.getchildren()
    for appointment in appointments:
        appt_children = appointment.getchildren()
        for appt_child in appt_children:
            if appt_child.tag != "comments":
                print ("%s=%s" % (appt_child.tag, appt_child.text))
            else:
                for comment in appt_child:
                    print ("%s=%s" % (comment.tag, comment.text))

 
#----------------------------------------------------------------------
if __name__ == "__main__":
    parseXML("appointments.xml")
