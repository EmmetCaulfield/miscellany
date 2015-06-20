#!/bin/sed -nf
/<title>\(.*\)/ {           # If the line matches the start tag:
    s//\1/                  #   Keep stuff after the start tag
    /<\/title>/!{           #   If the end-tag is *NOT* on this line
        h                   #     Save to hold space
        : loop              #     
        n                   #     Go on to the next line
        /\(.*\)<\/title>/{  #     If we match the end tag
            s//\1/          #       Keep stuff up to the end tag
            H               #       Append to hold space
            g               #       Fetch hold space to pattern space
            s/\n\+/ /g      #       Replace newlines with spaces
            b print         #       Branch to print, below
        }
        /<\/title>/!{       #     If we do NOT match the end tag
            H               #       Append this line to hold space
            b loop          #       Go back and try the next line
        }
    }    
    /\(.*\)<\/title>/{      # If the end-tag *IS* on this line
        s//\1/              #   Keep stuff before the end tag
    }
    : print                 # By here, the title is in pattern space
    s/^ \+//                # Trim leading spaces
    s/ \+$//                # Trim trailing spaces
    s/ \+/ /g               # Normalize internal spaces
    p                       # Print the title
}
