from ConfigParser import SafeConfigParser

def parseRunfile(runfile):
   parser = SafeConfigParser()
   parser.read(runfile)
   pars = {}
# for section_name in parser.sections()   
   for name, value in parser.items('DEFAULT'):
       pars[name] = value
       print ' %s = %s' % (name, value)
    return(pars)

