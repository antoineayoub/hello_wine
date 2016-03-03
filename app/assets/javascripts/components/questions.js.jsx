var Questions = React.createClass({
  getInitialState: function(){
    return {
      // final query to be built by adding keys as topic & value as value-answer
      lastQuestion: false,
      geoLocation: {},
      page: 0,
      question: this.props.questions[0],
      finalQuery: [],
      nbWines: 10000
    }
  },
  // component did mount OR component did load
  getGeoloc: function(){
    var that = this;
    navigator.geolocation.getCurrentPosition(success);
    function success(position) {
      var positionInformation = { latitude: position.coords.latitude, longitude: position.coords.longitude }
      that.setState({
        geoLocation: positionInformation
      })
    }
  },
  updateQuery: function(value){
    // why is called each time???
    if (navigator.geolocation) {
      this.getGeoloc();
    };
    var topic = this.state.question.topic;
    var intQuery = this.state.finalQuery;
    var newHash = {};
    newHash[topic] = value;
    intQuery.push(newHash);
    this.setState({
      finalQuery: intQuery
    });
  },
  handleSkipQuestion: function(){
    var that = this;
    this.updateQuery(""); // why using this???? still not clear!!!!!
    if (this.state.page == this.props.questions.length - 2) {
      this.setState({
        lastQuestion: true
      })
    }
    this.setState({
      page: that.state.page + 1,
      question: that.props.questions[(that.state.page + 1)]
    })
  },
  handleAnswer: function(value){
    var that = this;
    if (this.state.page == this.props.questions.length - 2) {
      this.setState({
        lastQuestion: true
      })
    }
    $.ajax({
      type: 'POST',
      data: {wine: { topic: this.state.question.topic, value: value }},
      url: Routes.wines_filtering_path({format: 'json'}),
      success: function(data) {
        console.log(data["nb_wines"]);
        that.setState({
          page: that.state.page + 1,
          question: that.props.questions[(that.state.page + 1)],
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
          questionNumber={this.state.questionNumber}
          isLastQuestion={this.state.lastQuestion}
          onQuestionClicks={this.updateQuery}
          geoLocation={this.state.geoLocation}
          finalQuery={this.state.finalQuery} />
        <QuestionBackButton onSkipQuestion={this.handleSkipQuestion}/>
        <QuestionFooter nbWines={this.state.nbWines}/>
      </div>
    )
  }
});

