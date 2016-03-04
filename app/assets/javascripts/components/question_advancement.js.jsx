var QuestionAdvancement = React.createClass({

  render: function() {
    var advClass = 'question-advancement nothing';
    if (this.props.page === 1) advClass += ' third';
    else if (this.props.page === 2) advClass += ' two-third';
    else if (this.props.page === 3) advClass += ' full';

    return (
      <div className="question-advancement">
        <div className={advClass}>
        </div>
      </div>
    )
  }
});

