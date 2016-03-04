var Questions = React.createClass({
  getInitialState: function(){
    return {
      // final query to be built by adding keys as topic & value as value-answer
      lastQuestion: false,
      geoLocation: {},
      page: 0,
      question: this.props.questions[0],
      finalQuery: [],
      nbWines: null
    }
  },
  componentWillMount: function(){
    // to compute the number of wines as setState
    // why not updating initial state? not computed before initial state but in console quite clear
    // http://busypeoples.github.io/post/react-component-lifecycle/
    var that = this;
    console.log(1);
    $.ajax({
      type: 'POST',
      data: {wine: { topic: "", value: "" }},
      url: Routes.wines_filtering_path({format: 'json'}),
      success: function(data) {
        that.setState({
          nbWines: data["nb_wines"]
        });
        console.log("all wines in db: "+data["nb_wines"]);
      }
    })
  },
  componentDidMount: function(){
    // called only once?
    // can i update the wines based on this with an AJAX call & with location?
    var that = this;
    navigator.geolocation.getCurrentPosition(success);
    function success(position) {
      var positionInformation = { latitude: position.coords.latitude, longitude: position.coords.longitude }
      console.log("Geolocation performed")
      that.setState({
        geoLocation: positionInformation
      })
    }
  },
  updateQuery: function(value){
    var topic = this.state.question.topic;
    var intQuery = this.state.finalQuery;
    var newHash = {};
    newHash[topic] = value;
    intQuery.push(newHash);
    this.setState({
      finalQuery: intQuery
    });
  },
  handleNextPage: function(){
    var that = this;
    this.setState({
      page: that.state.page + 1
    })
  },
  handleSkipQuestion: function(){
    var that = this;
    this.updateQuery(""); // why using this???? still not clear!!!!!
    if (this.state.page == this.props.questions.length - 1) {
      this.setState({
        lastQuestion: true
      })
    }
    this.setState({
      question: that.props.questions[(that.state.page)]
    })
  },
  handleAnswer: function(value){
    var that = this;
    if (this.state.page == this.props.questions.length - 1) {
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
          question: that.props.questions[(that.state.page)],
          nbWines: data['nb_wines']
        })
      }
    })
  },
  render: function() {
    return (
      <div>
        <QuestionBanner question={this.state.question} />
        <QuestionAdvancement page={this.state.page} />
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
          updateQuery={this.updateQuery}
          geoLocation={this.state.geoLocation}
          finalQuery={this.state.finalQuery}
          nextPage={this.handleNextPage} />
        <QuestionBackButton
          onSkipQuestion={this.handleSkipQuestion}
          nextPage={this.handleNextPage} />
        <QuestionFooter nbWines={this.state.nbWines}/>
      </div>
    )
  }
});

