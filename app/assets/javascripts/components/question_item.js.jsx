var QuestionItem = React.createClass({

  handleClick: function(){
    if (this.props.isLastQuestion === true) {
      this.props.onQuestionClicks(this.props.value);
      console.log("last question");
      var geo   = this.props.geolocation;
      var query = this.props.finalQuery;
      document.location.href = "/wines?color="+query[0]['color']+"&pairing="+query[1]['meal']+"&price="+query[2]['price']+"&latitude="+geo['latitude']+"&longitude="+geo['longitude'];
    } else {
      this.props.onQuestionClick(this.props.value);
      this.props.onQuestionClicks(this.props.value);
    };
  },

  render: function() {

    return (
      <div className="col-xs-12">
        <div className="padded-top-bottom-xs">
          <a className="btn btn-question" onClick={this.handleClick}>
            {this.props.answer}
          </a>
        </div>
      </div>
    )
  }
});



