### Changelog ###

This file contains highlights of what changes on each version of the cargo package.

#### Pub version 0.2.0+1 ####

- fix some small issues with mongodb implementation

#### Pub version 0.2.0 ####

- update implementation to Cargo 0.5.0
- improve redis implementation (still experimental)
- better use of collections

#### Pub version 0.1.3 ####

- adding remove dispatch to bigcargo, so you will receive data change events when something get deleted.

#### Pub version 0.1.2+4 ####

- Fixing bug in export method of mongoDB!

#### Pub version 0.1.2+2 & 0.1.2+3 ####

- decode value when doing an export()
- solve issue on dispatching

#### Pub version 0.1.2+1 ####

- Improvements to dispatch on setItem, mongo impl

#### Pub version 0.1.2 ####

- Implemented export() function for mongoDB

#### Pub version 0.1.1+1 & 0.1.1+2 & 0.1.1+3 ####

- make mongodb impl better by fixing 'getItem' issue

#### Pub version 0.1.1 ####

- Add redis implementation to the project
- Adapt implemenations to Future<int> to retrieve the length of the keys into the nosql db

#### Pub version 0.1.0 & 0.1.0+1 ####

- Setup of the project
- Initial implemenation of mongodb