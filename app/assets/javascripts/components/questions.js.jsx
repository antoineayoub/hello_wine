var Questions = React.createClass({
  getInitialState: function(){
    return {
      // final query to be built by adding keys as topic & value as value-answer
      finalQuery: [],
      questionNumber: "Q1",
      question: this.props["Q1"],
      nbWines: 10000
    }
  },
  handleSkipQuestion: function(){
    var that = this;
    var currentTopic          = this.props[this.state.questionNumber].topic;
    var finalQuery            = this.state.finalQuery;
    // push not working
    var newQuery              = finalQuery.push({currentTopic: ""});
    var currentQuestionNumber = parseInt(this.state.questionNumber.split("")[1]);
    var nextQuestion          = "Q" + ( currentQuestionNumber + 1 );
    this.setState({
      questionNumber: nextQuestion,
      question: that.props[nextQuestion],
      finalQuery: newQuery
    })
  },
  handleAnswer: function(topic, value, answer, questionNumber){
    // questinNumber can be removed / use state instead
    var that = this;
    var currentQuestionNumber = parseInt(questionNumber.split("")[1]);
    var nextQuestion          = "Q" + ( currentQuestionNumber + 1 );
    $.ajax({
      type: 'POST',
      data: {wine: { topic: topic, value: value }},
      url: Routes.wines_filtering_path({format: 'json'}),
      success: function(data) {
        console.log(data["nb_wines"]);
        that.setState({
          questionNumber: nextQuestion,
          question: that.props[nextQuestion],
          nbWines: data['nb_wines']
        })
      }
    })
  },
  render: function() {
    return (
      <div>
        <QuestionBanner question={this.state.question} />
        <div className="col-xs-12">
          <div className="title text-center padded-1">
            <div>{this.state.question.question}</div>
          </div>
        </div>
        <QuestionForm
          onQuestionClick={this.handleAnswer}
          question={this.state.question}
          questionNumber={this.state.questionNumber} />
        <QuestionBackButton onSkipQuestion={this.handleSkipQuestion}/>
        <QuestionFooter nbWines={this.state.nbWines}/>
      </div>
    )
  }
});

