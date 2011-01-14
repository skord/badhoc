/*
 
 File: script.js
 
 Abstract: JavaScript functionality for the Finger Tips sample.
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by 
 Apple Inc. ("Apple") in consideration of your agreement to the
 following terms, and your use, installation, modification or
 redistribution of this Apple software constitutes acceptance of these
 terms.  If you do not agree with these terms, please do not use,
 install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. 
 may be used to endorse or promote products derived from the Apple
 Software without specific prior written permission from Apple.  Except
 as expressly stated in this notice, no other rights or licenses, express
 or implied, are granted by Apple herein, including but not limited to
 any patent rights that may be infringed by your derivative works or by
 other works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2008 Apple Inc. All Rights Reserved.
 
*/
 
/* ============================== CONSTANTS ============================== */

// the number of posters in the ring
const NUM_POSTERS = 10;

// the radius of the ring, used for Z translations
const RADIUS = 235;

// poster frame directory
const POSTER_PREFIX = '';

// the angle of a complete rotation
const FULL_ROTATION = Math.PI * 2;

// the screen width in pixels
const SCREEN_WIDTH = 320;

/* ============================== GLOBALS ============================== */

// some DOM elements we'll need to access in various points
var ring, ring_container, info_container;

// the index of the item that was last selected
var current_index = -1;

/* ============================== INIT ============================== */

// called when the document is ready to go, this is the first entry point
// as registered by the addEventListener call at the very end of this file
function init () {
  // register pointers to the DOM elements we'll be using
  ring = document.getElementById('ring');
  ring_container = document.getElementById('ring-container');
  info_container = document.getElementById('info-pane');

  // populate the ring
  populate_ring();

  // let the ring controller perform all pre-flight operations
  // needed to deal with interactions
  ring_controller.init();

  // attach the action for the back button and pre-load its touched state
  document.getElementById('info-back-button').addEventListener('touchend', go_back, false);
  (new Image()).src = 'ui/back_button_touched.png';

  // attach the action for the play button and pre-load its touched state
  document.getElementById('info-play-button').addEventListener('touchend', play_movie, false);
  (new Image()).src = 'ui/play_button_ring.png';

  // hide the address bar once everything has loaded
  window.setTimeout(function() { window.scrollTo(0, 0); }, 2000);  
};

/* ============================== RING POPULATION ============================== */

// populates the ring with items
function populate_ring () {
  // build each item one by one
  for (var i = 0; i < NUM_POSTERS; ++i) {
    // get a fresh item populated with data
    var item = build_ring_element(data[i]);
    // set the incremental rotation on this item, projecting it forward as well
    var angle = -i * (FULL_ROTATION / NUM_POSTERS);
    item.style.webkitTransform = 'rotateX(' + angle + 'rad) translateZ(' + RADIUS + 'px)';
    // add an event listener to start an interaction on this item
    // note the event handler is the ring_controller object which then has
    // to implement the handleEvent() method to deal with the event
    item.addEventListener('touchstart', ring_controller, false);
    // track its index so we can retrieve it later when we select this item
    item.index = i;
    // add the item to the ring's DOM tree
    ring.appendChild(item);
  }
};

// builds a single element populated with the data passed as parameter
function build_ring_element (item_data) {
  // create a container for this new item
  var item = document.createElement('li');
  // build the element for the poster frame
  var image = document.createElement('div');
  image.className = 'image';
  image.style.backgroundImage = 'url(' + (POSTER_PREFIX + item_data.image) + ')';
  // build the container for the description
  var text = document.createElement('div');
  text.className = 'desc';
  // build the title
  var title = document.createElement('h1');
  title.textContent = item_data.title;
  text.appendChild(title);
  // build the blurb
  var blurb = document.createElement('p');
  blurb.textContent = item_data.desc;
  text.appendChild(blurb);
  // add it all to the container's DOM tree
  item.appendChild(image);
  item.appendChild(text);
  // done, return the ring element we just built
  return item;
};

/* ============================== RING CONTROLLER ============================== */

// set up our controller object which will be responsible to deal with
// all interaction with the ring
var ring_controller = {
  currentRotation : 0 // stores the ring rotation at all times, in radians
};

// performs all pre-flight operations needed to deal with interactions
ring_controller.init = function () {
  // register event handler for transition end on the ring so
  // that we can trigger the selection callback when done
  ring.addEventListener('webkitTransitionEnd', this, false);  
};

// updates the rotation of the ring to the specified radians angle
ring_controller.setRotation = function (rotation) {
  this.currentRotation = rotation;
  ring.style.webkitTransform = 'rotateX(' + this.currentRotation + 'rad)';
};

/* ============================== RING EVENT ROUTING ============================== */

// this method is called when an event we registered a listener for is triggered,
// implementing this method makes our object conform to the EventListener interface,
// see http://www.w3.org/TR/DOM-Level-2-Events/events.html#Events-EventListener
ring_controller.handleEvent = function (event) {
  // dispatch the event to the right method based on its type
  switch (event.type) {
    case 'touchstart' :
      this.interactionStart(event);
      break;
    case 'touchmove' :
      this.interactionMove(event);
      break;
    case 'touchend' :
      this.interactionEnd(event);
      break;
    case 'webkitTransitionEnd' :
      this.selectionTransitionDone(event);
      break;
  }
};

/* ============================== RING INTERACTION ============================== */

// called when a touchstart event is received on an item
ring_controller.interactionStart = function (event) {
  // keep track this interaction's start state as we will need
  // this information to conduct the dragging operation
  this.startY = event.touches[0].pageY;
  this.startRotation = this.currentRotation;
  this.startYAngle = this.getAngleAtY(this.startY);
  // set the touchMoved flag to false as we're just starting a new interaction
  this.touchMoved = false;
  // keep  track what item has started the interaction so that we can
  // refer back to it later if we detect a selection
  this.currentItem = event.currentTarget;
  // finally, hook up event capture so that we handle all touch events from now on,
  // wherever touches happen
  window.addEventListener('touchmove', this, true);
  window.addEventListener('touchend', this, true);
};

// called when a touchmove event is received
ring_controller.interactionMove = function (event) {
  // prevent the default UI page panning behavior
  event.preventDefault();
  // track that we have moved at least once such that later
  // we know that this is not a selection but a drag interaction
  this.touchMoved = true;
  // figure out the angle delta since the start of the interaction
  var y = event.touches[0].pageY;
  var angle_delta = this.startYAngle - this.getAngleAtY(y);
  // and update the ring rotation
  this.setRotation(this.startRotation - angle_delta);
};

// called when a touchend event is received
ring_controller.interactionEnd = function (event) {
  // stop listening to touch events as we're done with our interaction
  window.removeEventListener('touchmove', this, true);
  window.removeEventListener('touchend', this, true);
  // perform a selection if we have not moved the finger
  if (!this.touchMoved) {
    this.performSelection();
  }
};

// returns the ring's rotation angle from the center of the screen to
// the provided coordinate in the y-axis
ring_controller.getAngleAtY = function (y) {
  return Math.acos((y - RADIUS) / RADIUS);
};

/* ============================== RING SELECTION ============================== */

// called when a selection is detected
ring_controller.performSelection = function () {
  // first, let's figure what the ring rotation angle to center on the selection
  var new_rotation = this.currentItem.index * (FULL_ROTATION / NUM_POSTERS);
  // will we actually need to animate?
  var immediate_selection = (this.currentRotation == new_rotation);
  // tell our callback that we've started the selection process
  item_being_selected(this.currentItem, immediate_selection);
  // if the selection is not immediate, start the animated transition
  if (!immediate_selection) {
    // set up the transition duration so that the next update to the ring's
    // -webkit-transform property is animated
    ring.style.webkitTransitionDuration = '0.5s';
    // now set the new value to transition to via .setRotation, which
    // updates the ring's -webkit-transform property
    this.setRotation(new_rotation);
  }
};

// this is called when the ring is animated and the transition is complete
ring_controller.selectionTransitionDone = function (event) {
  // we got called following an animated rotation to center
  // so tell our callback the selection is done
  item_selected(this.currentItem);
  // ensure we do not have any transition set up as this would
  // not fit well with a dragging interaction
  ring.style.webkitTransitionDuration = '0';
};

/* ============================== INFO VIEW TRANSITIONS ============================== */

// this function is called from ring_controller.performSelection when a selection is
// detected before the ring starts spinning to center the newly selected item
function item_being_selected (item, is_immediate) {
  // track the index of the selected item
  current_index = item.index;
  // populate the info pane straight away if the selection is immediate
  // and trigger the transition into the info pane as well
  if (is_immediate) {
    update_info_pane();
    item_selected(item);
  }
  // otherwise wait a little to populate so that the animation is not delayed
  // by the rendering operations going on in the info pane
  else {
    setTimeout(update_info_pane, 10);
  }
};

// this function is called from ring_controller.performSelection when a selection is
// detected once the ring has finished spinning to center the newly selected item
function item_selected (item) {
  // now slide the ring out and the info pane in, the core transition
  // CSS properties are already set up in the style sheet
  ring_container.style.webkitTransform = print_translate_x(-SCREEN_WIDTH);
  info_container.style.webkitTransform = print_translate_x(0);
};

// called when the back button is pressed, the callback is registered in init()
function go_back () {
  // slide the ring in and the info pane out, the core transition
  // CSS properties are already set up in the style sheet
  ring_container.style.webkitTransform = print_translate_x(0);
  info_container.style.webkitTransform = print_translate_x(SCREEN_WIDTH);
};

// update the contents in the info pane based on current_index
function update_info_pane () {
  // get the data for the newly selected item
  var item_data = data[current_index];
  // update each DOM element in the info pane tree
  document.getElementById('info-title').textContent = item_data.title;
  document.getElementById('info-image').src = POSTER_PREFIX + item_data.image;
  document.getElementById('info-description').textContent = get_long_desc();
  document.getElementById('info-link').textContent = item_data.link;
  document.getElementById('info-date').textContent = item_data.date;
};

/* ============================== MOVIE PLAYING ============================== */

// called when the play button is pressed, the callback is registered in init()
function play_movie (event) {
  // get a pointer to the <embed> media element in the tree
  var movie = document.getElementById('movie');
  // get the path to the page as we must create absolute URLs for the movie URL
  // and replace the last part with the path to our movie
  var current_path = window.location.href.split('/');
  current_path[current_path.length - 1] = data[current_index].movie;
  // update the url of the movie with the .SetURL() media API
  movie.SetURL(current_path.join('/'));
  // play the movie, automatically entering full-screen
  // thanks to another one of the media APIs
  movie.Play();
};

/* ============================== UTILS ============================== */

// utility function to print the right CSS transform for a translateX()
function print_translate_x (x) {
  return 'translateX(' + x + 'px)';
};

// index of the last used phrase
var phrase_count = 0;

// returns the next long description
function get_long_desc () {
  return PARAGRAPHS[phrase_count++ % PARAGRAPHS.length];
};

/* ============================== INIT ============================== */

// call init() when the document has finished loading and we are ready
window.addEventListener('load', init, false);
