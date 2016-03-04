var QuestionItem = React.createClass({
  getInitialState: function(){
    return {
      isclicked: false
    }
  },
  handleClick: function(){
    this.setState({
      isclicked: true
    });
    var that = this;
    if (this.props.isLastQuestion === true) {
      this.props.updateQuery(this.props.value);
      this.props.nextPage();
      var geo   = this.props.geolocation;
      var query = this.props.finalQuery;
      setTimeout(function(){
        document.location.href = "/wines?color="+query[0]['color']+"&pairing="+query[1]['meal']+"&price="+query[2]['price']+"&latitude="+geo['latitude']+"&longitude="+geo['longitude'];
      }, 1000);
    } else {
      this.props.nextPage();
      setTimeout(function(){
        that.props.onQuestionClick(that.props.value);
        that.props.updateQuery(that.props.value);
      },500);
    };
      setTimeout(function(){
    that.setState({
      isclicked: false
    });
      }, 300);
  },
  render: function() {
    var btnClass = classNames({
      "btn btn-question": true,
      "is-clicked": this.state.isclicked
    });
    return (
      <div className="col-xs-12">
        <div className="padded-top-bottom-xs">
          <a className={btnClass} onClick={this.handleClick}>
            {this.props.answer}
            <i className="fa fa-chevron-right"></i>
          </a>
        </div>
      </div>
    )
  }
});



