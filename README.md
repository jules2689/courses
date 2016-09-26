# Courses

Musings in :computer: Computer Science Education :computer:

The repository is intended to gather a series of essential courses and skills into a succinct and central location.
Each course is intended to be concise, but also explain why the skill or course is necessary.

This is not intended to cover the entire set of courses at a university, but be a set of courses that can get someone started on the right track.

In the end, this repo should have outlines for courses in:
 - math
 - logic
 - philosophy
 - software design
 - databases
 - networking
 - security
 - systems & infrastructure
 - data structures
 - algorithms
 - etc.
 
Feel free to contribute content. I do suspect this will end up being more than computer science as well.
 
# Development
 
- Courses are represented as a persistent [yaml file](https://github.com/jules2689/courses/blob/master/courses.yml), as are the categories at the top of the file.
- `bin/render` will render the persistent yaml file into the `doc` folder.
- `bin/server` starts a basic Python HTTP server (required for the link structure)
- `bin/testunit` runs a series of tests to make sure everything runs smoothly :ok_hand:

# General Concepts

This is a take on the MVC design pattern, but with a renderer replacing the "C" (controller).
Given this, the [yaml file](https://github.com/jules2689/courses/blob/master/courses.yml) is loaded into model objects which are then renderered into erb templates and saved into `docs/`
The entire thing is hosted on Github pages.

### Renderers
- A [website renderer](https://github.com/jules2689/courses/blob/master/lib/renderers/website.rb) renders the website as a whole, handling things like static files (assets) and directing other renderers.
- The [components renderer](https://github.com/jules2689/courses/blob/master/lib/renderers/components.rb) handles rendering individual compontents, such as a course, section, or category.
