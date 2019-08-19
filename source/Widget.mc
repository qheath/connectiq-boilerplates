using Toybox.Application;
using Toybox.WatchUi;

module Widget {

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
      return [new View(), new Delegate()];
    }

  }

  class View extends WatchUi.View {

    function initialize() {
      View.initialize();
    }

    function onLayout(dc) {
      setLayout(Rez.Layouts.Widget(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {
      findDrawableById("counter").setText(counter.toString());

      View.onUpdate(dc);
    }

    function onHide() {
    }

  }

  class Delegate extends WatchUi.BehaviorDelegate {

    function initialize() {
    }

    function onSelect() {
      counter++;
      WatchUi.requestUpdate();
      return true;
    }

  }

}
