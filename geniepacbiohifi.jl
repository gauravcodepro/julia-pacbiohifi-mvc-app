#! /usr/bin/env julia
# Author Gaurav
# Universitat Potsdam
# Date 2024-6-30
# a pacbiohifi MVC application for the live stream of your sequencing reads and display inline with the web-browser.
# 2024-6-30 morning 5 minutes to code and run the function and templating this Genie application
# 2024-6-30 afternoon 1-2 hour to make the HTML and add the searchlight.jl and javascript
# release today. 

using Genie
using CairoMakie
using DataFrames
using SearchLight
Genie.Generator.newapp_mvc("PacBiohifi-MVC")

using Genie.Router
route("/") do
 serve_static_file("PacBiohifiRead.html")
end

function readpacbiohifi(pacbiohififastq)
  # catching the regular pattern instead of the reading and storing the line as intermediate variable 
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

function length(pacbiohififastq)
    readpacbio = readlines(pacbiohififastq)
    pacbioiddnaunpack = String[]
    pacbiodnastring = String[]
    pacbiolengthstring = Int8[]
    for i in readpacbio
      if startswith(line, "@")
         push!(pacbioiddnaunpack, (line)[1])
      end 
  # implementing the regular expression of the string start rather than iterating over the lines making it O(n2) faster.
      if startswith(line, r"A|T|G|C")
        push!(pacbiodnastring, line)
      end
     pacbiolengthstring = union(map(length,pacbiodnastring))
    end
end 

function displaypacbio(pacbiohififastq)
   SearchLight.Migrations.init()
    # make a backhand SQL database and store the reads for the dispatch and faster I/0 
