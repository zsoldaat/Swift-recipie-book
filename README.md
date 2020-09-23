# Swift-recipie-book

This is a recipie book app that allows you to add, edit, and view your own recipies, and then generate grocery lists based on the ingredients in those recipies.
The items in your grocery list are generated using an algorithm that takes in to account your preference for the recipie that you set when you input the recipie, as well as how recently the item has appeared in a previous grocery list. This means that your more preferred recipies will be more likely to appear, and a recipie that was in your previous grocery list will be less likely to appear in your next grocery list.
The units of the ingredients are meant to be open-ended so you can do what makes sense for you i.e. 1 Bacon could be 1 strip of bacon, or one whole pack of bacon.

Here is a demo of the app in action: https://youtu.be/MwDBgBIHgg8

Future plans for this app include an entire re-write using SwiftUI, and improvements to the algorithm so that it will suggest recipies combiniations that include whole numbers for ingredients i.e. if one recipie on your grocery list calls for half an onion, it will try to suggest another recipie that calls for half an onion. 
