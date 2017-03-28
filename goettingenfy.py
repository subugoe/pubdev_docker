#!/usr/bin/env python
# vim: set fileencoding=UTF8 :

# Files and directories to be searched

import glob, os, sys, getopt, re, collections

reload(sys)
sys.setdefaultencoding('utf-8')

base = './src'
# Where to look for replacements
places = ['lib', 'fixes', 'config*', 'public', 'views']

# Function needed to allow regular expression patterns in the replacement list
def r (pattern):
    return re.compile(pattern)

replacements = collections.OrderedDict()

# What should be replaced
# Use Python raw strings (r'') to make sure that strings with backslashes are not interpreted as escape sequences
# Use the function r() to wrap up things that are regular expressions

# Small history
# 30.1.: Some changes from 894b3660d750cefbe1ce13ea2dbb800bf498ae4d integrated
# 28.3.: Strings from older versions removed new added and adapt email adresses
replacements['http://ekvv.uni-bielefeld.de/pers_publ/publ/PersonDetail.jsp?personId='] = ''
replacements['https://ekvv.uni-bielefeld.de/pers_publ/publ/PersonDetail.jsp?personId='] = ''
replacements[r'fix: [\"add_field(\'host\',\'http://localhost:5001\')\"]'] = r'fix: [\"add_field(\'host\',\'http://pub-dev.sub.uni-goettingen.de\')\"]'
replacements[r'\\line PUB: {\\field{\\*\\fldinst HYPERLINK https://pub.uni-bielefeld.de/$bag/$pub->{_id}}{\\fldrslt https://pub.uni-bielefeld.de/$bag/$pub->{_id}}}'] = r'\\line GRO: {\\field{\\*\\fldinst HYPERLINK https://gro.sub.uni-goettingen.de/$bag/$pub->{_id}}{\\fldrslt https://gro.sub.uni-goettingen.de/$bag/$pub->{_id}}}'
replacements[r'{\\field{\\*\\fldinst HYPERLINK https://pub.uni-bielefeld.de/$bag/$pub->{_id}}{\\fldrslt'] = r'{\\field{\\*\\fldinst HYPERLINK https://gro.sub.uni-goettingen.de/$bag/$pub->{_id}}{\\fldrslt'
replacements[r'\\line PhilLister: {\\field{\\*\\fldinst HYPERLINK http://phillister.ub.uni-bielefeld.de/$bag/$ext->{phillister}}{\\fldrslt $ext->{phillister}}}'] = ''
replacements['http://localhost:5001/oai'] = 'http://pub-dev.sub.uni-goettingen.de/oai'
replacements['PUB - Publications at LibreCat University'] = 'GRO - Göttingen Research Online'
replacements['oai:pub.librecat.org:1585315'] = 'oai:pub-dev.sub.uni-goettingen.de:2737399'
replacements['https://pub.uni-bielefeld.de'] = 'https://www.sub.uni-goettingen.de'
replacements['http://pub-dev.ub.uni-bielefeld.de/publication?fmt=jsonintern&q='] = 'https://gro.sub.uni-goettingen.de/publication?fmt=jsonintern&q='
replacements['pub.librecat.org'] = 'pub-dev.sub.uni-goettingen.de'
replacements['LibreCat University'] = 'Göttingen University'
replacements['Bielefeld University'] = 'Göttingen University'
replacements['Universität Bielefeld'] = 'Georg-August-Universität Göttingen'
replacements['Universitätsbibliothek Bielefeld'] = 'Niedersächsische Staats- und Universitätsbibliothek Göttingen'
replacements['Universitätsstr. 25, 33615 Bielefeld'] = 'Platz der Göttinger Sieben 1, 37073 Göttingen'
replacements['Bielefeld'] = 'Göttingen'
replacements[r('PUB([^\w])')] = r'GRO\1'
replacements[r('([^"\w])UniBi([^"\w])')] = r'\1UniGö\2'
replacements['Autor arbeitet an der Uni LibreCat.'] = 'Autor arbeitet an der Uni Göttingen.'
replacements['Hiermit stelle ich der Universit&auml;t LibreCat dieses'] = 'Hiermit stelle ich der Universit&auml;t Göttingen dieses'
replacements['Publikationen an der Universit&auml;t LibreCat'] = 'Publikationen an der Universit&auml;t Göttingen'
replacements['Ehemaliger LibreCat Forscher'] = 'Ehemaliger Göttinger Forscher'
replacements['LibreCat Autoren'] = 'Göttinger Autoren'
replacements['LibreCat Herausgeber'] = 'Göttinger Herausgeber'
replacements['Ehemalige LibreCat Autoren'] = 'Ehemalige Göttinger Autoren'
replacements[r'local_brand: "LibreCat"'] = 'local_brand: "GRO"'
#replacements['LibreCat Only'] = 'GRO Only'
replacements['helpdesk@librecat.org'] = 'support-gro@sub.uni-goettingen.de'
replacements['Publications at LibreCat University'] = 'Publications at Göttingen University'
replacements['Former LibreCat University Researcher'] = 'Former Göttingen University Researcher'
replacements['LibreCat Authors'] = 'Göttingen Authors'
replacements['LibreCat Editors'] = 'Göttingen Editors'
replacements['Former LibreCat Authors'] = 'Former Göttingen Authors'
replacements['Activate if LibreCat author.'] = 'Activate if GRO author.'
replacements['Published while not employed at LibreCat'] = 'Published while not employed at Göttingen'
replacements['LibreCat Only'] = 'GRO Only'
# Note that the case of only is the difference
replacements['LibreCat only'] = 'GRO only'
replacements['Local Access (Nur LibreCat)'] = 'Local Access (Nur GRO)'
replacements['Nur LibreCat'] = 'Nur GRO'
replacements['I herewith place this document at LibreCat University'] = 'I herewith place this document at Göttingen University'
replacements['Activate if LibreCat author.'] = 'Activate if Göttingen author.'
replacements['L6000-0538'] = ''
replacements['24060-6'] = '2020450-4'
replacements['helpdesk@librecat.org'] = 'support-gro@sub.uni-goettingen.de'
replacements['PEVZ-ID'] = 'GRO-ID'
replacements['appname: "LibreCat"'] = 'appname: "Göttingen Research Online"'
replacements['Open Data PUB'] = 'Open Data GRO'
replacements['Ver&ouml;ffentlicht vor/nach Besch&auml;ftigung an der LibreCat'] = 'Ver&ouml;ffentlicht vor/nach Besch&auml;ftigung an der Universit&auml;t G&ouml;ttingen'
#This lines are used to set up the CSL thing
replacements['engine: none'] = 'engine: csl'
replacements['  url: \'http://localhost:8085\''] = '  url: \'http://citeproc:8080\''
# This is a special case, that only applies to one file
replacements['PUB'] = {'to': 'GRO', 'files': ['views/embed/links_js.tt']}


#List to count if all replacements have been made
replaced = []

def find_files (files):
    ret = []
    for file in files:
        ret.extend(glob.glob(file))
    return ret

def change_file (file, edit, verbose):
    content = ''
    with open (file, 'rt') as infile:
        linenr = 0
        result = False
        for line in infile:
            linenr += 1
            position = "File: " + file + ":" + str(linenr) + ": "
            for fro, to in replacements.items():
                if isinstance(fro, str):
                    if isinstance(to, str):
                        search = fro
                        newline = line.replace(fro, to)
                    elif isinstance(to, dict):
                        search = to['to']
                        if file in to['files']:
                            print "Got matching file: " + file + " for specific change of " + search
                            newline = line.replace(fro, to['to'])
                elif isinstance(fro, re._pattern_type):
                    if isinstance(to, dict):
                        print "Regex searches can't handle specific files, I will die by Type Errors"
                    search = fro.pattern
                    regex = fro
                    newline = regex.sub(to, line)
                if line != newline:
                    print position + "changed \"" + search + "\" "
                    if replacements[fro] == '':
                        print "(Warning, no replacement for  \"" + search+ "\")"
                    result = True
                    if verbose:
                        print "Change \"" + line + "\" to \"" + newline + "\""
                    line = newline
                    if fro not in replaced:
                        replaced.append(fro)
            content = content + newline
    if edit == True:
        resultfile = file + ".new"
    else:
        resultfile = file
    if result:
        with open(resultfile, 'w') as new_file:
            new_file.write(content)
        print "File " + resultfile + " written"

def main(argv):
    help = 'goettingenfy.py -s <srcdir>'
    test = False
    verbose = False
    try:
       opts, args = getopt.getopt(argv,"hvts:",["srcdir=",])
    except getopt.GetoptError:
       print help
       sys.exit(2)

    for opt, arg in opts:
      if opt == '-h':
         print help
         sys.exit()
      elif opt in ("-s", "--srcdir"):
         srcdir = arg
      elif opt == '-t':
         test = True
      elif opt == '-v':
         verbose = True
    os.chdir(srcdir)
    for searchroot in find_files(places):
        if os.path.isfile(searchroot):
            change_file(searchroot, test, verbose)
        elif os.path.isdir(searchroot):
            for root, dirs, files in os.walk(searchroot):
                for file in files:
                    change_file(os.path.join(root, file), test, verbose)
    for key in replacements.keys():
        if key not in replaced:
            if isinstance(key, str):
                r = key
            elif isinstance(key, re._pattern_type):
                r = key.pattern
            print "Warning: \"" + r + "\" was not replaced!"

if __name__ == "__main__":
   main(sys.argv[1:])
