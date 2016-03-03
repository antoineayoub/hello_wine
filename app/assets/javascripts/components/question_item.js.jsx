var QuestionItem = React.createClass({
  getInitialState: function(){
    return {
      clicked: false
    }
  },

  handleClick: function(){
    if (this.props.isLastQuestion === true) {
      this.props.onQuestionClicks(this.props.value);
      var geo   = this.props.geolocation;
      var query = this.props.finalQuery;
      document.location.href = "/wines?color="+query[0]['color']+"&pairing="+query[1]['meal']+"&price="+query[2]['price']+"&latitude="+geo['latitude']+"&longitude="+geo['longitude'];
    } else {
      this.props.onQuestionClick(this.props.value);
      this.props.onQuestionClicks(this.props.value);
    };
    this.setState({
      clicked: true
    })
  },

  // kframe 0% transform rotate 0
  // animation le nom de ma keyframe .3 infinite

  render: function() {
    var btnClasses = classNames({
      // 'is-clicked': this.state.clicked,
      'btn btn-question': true
    })
    return (
      <div className="col-xs-12">
        <div className="padded-top-bottom-xs">
          <a className={btnClasses} onClick={this.handleClick}>
            {this.props.answer}
          </a>
        </div>
      </div>
    )
  }
});



