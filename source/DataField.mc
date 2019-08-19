using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;

module DataField {

  var counter;

  class App extends Application.AppBase {

    function initialize() {
      AppBase.initialize();

      counter = 0;
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
      return [new View()];
    }

  }

  class View extends WatchUi.DataField  {

    function initialize() {
      DataField.initialize();
    }

    function compute(dc) {
      counter++;
    }

    function onLayout(dc) {
      setLayout(Rez.Layouts.DataField(dc));
    }

    function onUpdate(dc) {
      findDrawableById("counter").setText(counter.toString());

      View.onUpdate(dc);
    }

  }

}
