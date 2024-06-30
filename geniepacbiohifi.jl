#! /usr/bin/env julia
# Author Gaurav
# Universitat Potsdam
# Date 2024-6-30

# a pacbiohifi MVC application for the live stream of your sequencing reads and display inline with the web-browser.
# sunday morning 5 minutes to run the function and build this Genie application
# sunday afternoon 1 hour to make the HTML and add the searchlight.jl and javascript
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
      if startswith(line, r"A|T|G|C")
        push!(pacbiodnastring, line)
      end
     pacbiolengthstring = union(length,pacbiodnastring)
    end
end 

function displaypacbio(pacbiohififastq)
   SearchLight.Migrations.init()
    # make a backhand SQL database and store the reads for the dispatch and faster I/0 
