# -*- encoding: utf-8 -*-
require 'cora'
require 'siri_objects'
require 'eat'
require 'nokogiri'
require 'timeout'


#######
# 
# This is a simple XML parsing Plugin for Austrian DVB-T Television Channels 
# and can easily be adoptet for German channels.
# sorry for the strange code - im just learning Ruby :-) 
#
#     Remember to add the plugin to the "./siriproxy/config.yml" file!
#
######
#
# Das ist ein einfaches TV Programm plugin, welches die aktuellen österreichischen
# Sendungen DVB-T Kanäle vorliest 
# Kann auch einfach für die deutschen Kanäle angepasst werden (siehe 3SAT) 
#
#      ladet das Plugin in der "./siriproxy/config.yml" datei !
#
########
## ## ##  COMMENT CA MARCHE 
#
## # Quel est le programme en ce moment?
#
# Il suffit de dire une phrase avec «TV» (ou télévision) + «programme» dans une phrase complète
# Ou "programme" + Nom d'une requête spécifique
#
## # QU'est ce qu'il y a ce soit à la télévision
#
# "TV" + "Abend" oder "Primetime" für das komplette Hauptabendprogramm
# 
# 
# bei Fragen Twitter: @Muhkuh0815
# oder github.com/muhkuh0815/SiriProxy-TV
# Video Vorschau: http://www.youtube.com/watch?v=mTi9EC0M6Hw
#
#### ToDo
#
# Zeitabfrage - wie lange die sendung noch läuft
# bei spezifischer Abfrage - aktuelle + 2 folgende Sendungen
# Info Abfrage für Sendungsbeschreibung 
#
######

class SiriProxy::Plugin::TV < SiriProxy::Plugin
        
    def initialize(config)
        #if you have custom configuration options, process them here!
    end
    def doc
    end
    def docs
    end
    def dob
    end
 
 
 def tvprogramm(doc) #  grandes chaines - En ce moment
    begin
    doc = Nokogiri::XML(eat("www.zap-.fr/rss/rss.php?bouquet=2&thematique=1&day=now"))
    return doc
    rescue
     	doc = ""
    end
 end
 
 def tvprogrammsoir(doc) #  grandes chaines - Soir
 	begin
    doc = Nokogiri::XML(eat("http://www.zap-.fr/rss/rss.php?bouquet=2&thematique=1"))
    return doc
    rescue
     	doc = ""
    end
 end
 
 def tvprogrammtnt(dob) #  TNT - En ce moment
  	begin
    dob = Nokogiri::XML(eat("http://www.zap-.fr/rss/rss.php?bouquet=2&thematique=2&day=now"))
 	return dob
    rescue
    	dob = ""
    end
 end
 
 def tvprogrammtntsoir(dob) #  TNT - Soir
  	begin
    dob = Nokogiri::XML(eat("http://www.zap-.fr/rss/rss.php?bouquet=2&thematique=2"))
 	return dob
    rescue
    	dob = ""
    end
 end
 
 def cleanup(doc)
 	doc = doc.gsub(/<\/?[^>]*>/, "")
 	return doc
 end
 
 def dosund(dos)
 	if dos["&amp;"]
 		dos["&amp;"] = "&"
    end
    return dos
 end
 
#  télévision du soir - Grandes chaines et TNT

listen_for /(TV|télévision|programme|télé).*(soir|soirée)/i do
doc = tvprogrammsoir(doc)
dob = tvprogrammtntsoir(dob)
    if doc == NIL or doc == ""
        say "Il y a un problème lors de la lecture du programme télévision!"
    elsif dob == NIL or dob == ""
   		say "Il y a un problème lors de la lecture du programme télévision!"
    else
    	doc.encoding = 'utf-8'
    	dob.encoding = 'utf-8'
        docs = doc.xpath('//title')    
        dobs = dob.xpath('//title')            
        i = 1
        while i < docs.length 
        	dos = docs[i].to_s
         	dos = cleanup(dos)
         	doss = dos[0,5]
        	if doss == "TF1"
        		dos = dosund(dos)
        		tf1 = dos
        	elsif doss == "France 2"
        		dos = dosund(dos)
        		france2 = dos
        	elsif doss == "France 3"
        		dos = dosund(dos)
           		france3 = dos
        	elsif doss == "Canal+"
        		dos = dosund(dos)
        		canal+ = dos
        	elsif doss == "France 5"
        		dos = dosund(dos)
        		france5 = dos
        	elsif doss == "M6"
        		dos = dosund(dos)
        		m6 = dos
        	else
        	end
        	i += 1
        end
        i = 1
        while i < dobs.length
        	dos = dobs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	
        	if doss == "TNT"
        		dos = dosund(dos)
        		sat = dos
        	else
        	end
        	i += 1
        end
        	say " pour ce soir", spoken: " pour ce soir"
            say tf1
            say france2
            say france3
            say canal+
            say france5
            say m6
        end    
    request_completed
end

 
#  télévision - En ce moment - Grandes chaines et TNT
 
listen_for /(TV|télévision|programme|télé).*(télévision)/i do 
doc = tvprogramm(doc)
dob = tvprogrammtnt(dob)
    if doc == NIL or doc == "" 
        say "Il y a un problème lors de la lecture du programme télévision!"
    elsif dob == NIL or dob == ""
   		say "Il y a un problème lors de la lecture du programme télévision!"
    else
        doc.encoding = 'utf-8'
        dob.encoding = 'utf-8'
        docs = doc.xpath('//title')    
        dobs = dob.xpath('//title')            
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
         	doss = dos[0,5]
        	if doss == "TF1"
        		dos = dosund(dos)
        		tf1 = dos
        	elsif doss == "France 2"
        		dos = dosund(dos)
        		france2 = dos
        	elsif doss == "France 3"
        		dos = dosund(dos)
           		france3 = dos
        	elsif doss == "Canal+"
        		dos = dosund(dos)
        		canal+ = dos
        	elsif doss == "France 5"
        		dos = dosund(dos)
        		france5 = dos
        	elsif doss == "M6"
        		dos = dosund(dos)
        		m6 = dos
        	else
        	end
        	i += 1
        end
        i = 1
        while i < dobs.length
        	dos = dobs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	
        	if doss == "TNT"
        		dos = dosund(dos)
        		sat = dos
        	else
        	end
        	i += 1
        end
            say tf1
            say france2
            say france3
            say canal+
            say france5
            say m6
        end    
    request_completed
end

# TF1 - En ce moment

listen_for /(télévision|télé).*(OR tf1|la une)/i do
	doc = tvprogramm(doc)
    if doc == NIL or doc == "" 
        say "Il y a un problème lors de la lecture du programme télévision!"
    else
        doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "TF1"
        		dos = dosund(dos)
        		tf1 = dos
        	end
        	i += 1
        end
            say "En ce moment sur", spoken: "En ce moment sur,"       
            say tf11
        end    
    request_completed
end

# France 2 - En ce moment

listen_for /(télévision|télé).*(OR france2|deux)/i do
	doc = tvprogramm(doc)
	if doc == NIL or doc == ""
        say "Il y a un problème lors de la lecture du programme télévision!"
    else
        doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	
        	if doss == "France 2"
        		dos = dosund(dos)
        		france2 = dos
        	end
        	i += 1
        end
            say "En ce moment sur", spoken: "En ce moment sur"       
            say france2
        end    
    request_completed
end

# France 3 - En ce moment

listen_for /(télévision|télé).*(OR france3|trois)/i do
    doc = tvprogramm(doc)
	if doc == NIL or doc == ""
        say "Il y a un problème lors de la lecture du programme télévision!"
    else
        doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "France 3"
        		dos = dosund(dos)
        		france3 = dos
        	end
        	i += 1
        end
            say "En ce moment sur", spoken: "En ce moment sur"       
            say france3
        end    
    request_completed
end

# Canal + - En ce moment

listen_for /(télévision|télé).*(canal|plus|quatre)/i do
	doc = tvprogramm(doc)
	if doc == NIL or doc == ""
        say "Il y a un problème lors de la lecture du programme télévision!"
    else
    	doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "Canal+"
        		dos = dosund(dos)
        		canal+ = dos
        	end
        	i += 1
        end
            say "En ce moment sur", spoken: "En ce moment sur"       
            say canal+
        end    
    request_completed
end

# France 5 - En ce moment

listen_for /(télévision|télé).*(france5|arte|cinq)/i do
	doc = tvprogramm(doc)
    if doc == NIL or doc == ""
        say "Il y a un problème lors de la lecture du programme télévision!"
    else
		doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "France 5 "
        		dos = dosund(dos)
        		france5 = dos
        	end
        	i += 1
        end
            say "En ce moment sur", spoken: "En ce moment sur"       
            say france5
        end    
    request_completed
end

# M6 - En ce moment

listen_for /(télévision|télé).*(M6|six)/i do
	doc = tvprogramm(doc)
    if doc == NIL or doc == ""
        say "Il y a un problème lors de la lecture du programme télévision!"
    else
    	doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "M6"
        		dos = dosund(dos)
        		m6 = dos
        	end
        	i += 1
        end
            say "En ce moment sur", spoken: "En ce moment sur"       
            say m6
        end    
    request_completed
end

end
