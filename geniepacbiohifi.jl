#! /usr/bin/env julia

# sunday morning 5 minutes to run the function and build this Genie application
# sunday afternoon 1 hour to make the HTML and add the searchlight.jl and javascript
# release today. 

using Genie
Genie.Generator.newapp_mvc("TodoMVC")

using Genie.Router
route("/") do
 serve_static_file("PacBiohifiRead.html")
end


function readpacbiohifi(pacbiohififastq)
    readpacbio = readlines(pacbiohififastq)
    pacbioiddnaunpack = String[]
    pacbiodnastring = String[]
    for i in readpacbio
      if startswith(line, "@")
         push!(pacbioiddnaunpack, (line)[1])
      end 
      if startswith(line, r"A|T|G|C")
        push!(pacbiodnastring, line)
      end
    end
    return pacbioiddnaunpack
end 
    
