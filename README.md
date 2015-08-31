# Rails-Lite

This project consists of two main pieces: a simple version of ActiveRecord and a simple version of ControllerBase.
It allows for the creation of simple apps and can run a webrick server.

## Active-Lite

This model implements methods to interact with the database by implementing all, save, update, insert, and where 
methods, as well as object relational methods like has_many, belongs_to, and has_one_through.

## ControllerBase

This model allows the user to set up a router, run the server, parse parameters and render templates. It also
includes a setup file that will automatically setup of the default routes for listed controller classes.
