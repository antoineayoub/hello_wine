var QuestionItem = React.createClass({

  handleClick: function(){
    var value   = this.props.value;
    var topic   = this.props.topic;
    var answer  = this.props.answer;
    var questionNumber = this.props.questionNumber;
    this.props.onQuestionClick(topic, value, answer, questionNumber);
  },

  render: function() {

    return (
      <div className="col-xs-12">
        <div className="padded-top-bottom-xs">
          <a className="btn btn-question btn-next" onClick={this.handleClick}>
            {this.props.answer}
          </a>
        </div>
      </div>
    )
  }
});
