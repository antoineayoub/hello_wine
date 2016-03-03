var QuestionForm = React.createClass({
  render: function() {
    var that = this;
    return (
      <div>
        {this.props.question.answers.map(function(answer,index){
          return <QuestionItem
                    onQuestionClick={that.props.onQuestionClick}
                    answer={answer}
                    questionNumber={that.props.questionNumber}
                    value={that.props.question.values[index]}
                    topic={that.props.question.topic}
                    isLastQuestion={that.props.isLastQuestion}
                    onQuestionClicks={that.props.onQuestionClicks}
                    geolocation={that.props.geoLocation}
                    finalQuery={that.props.finalQuery}  />;
        })}
      </div>
    )
  }
});
// must add key to li items
