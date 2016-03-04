var QuestionBanner = React.createClass({
  render: function() {
    var currentImage = {
      height: '30vh',
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      backgroundImage: "linear-gradient(to bottom, rgba(82, 82, 82, 0.49) , rgba(61, 114, 180, 0.35)), url("+this.props.question.pic_url+")",
      transition: 'background-image 0.5s fadeOut'
    };
    var nextImage = {
      height: '30vh',
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      backgroundImage: "linear-gradient(to bottom, rgba(82, 82, 82, 0.49) , rgba(61, 114, 180, 0.35)), url("+this.props.nextQuestion.pic_url+")",
      transition: 'background-image 0.5s fadeIn'
    };
    return (
      <div>
        <div style={nextImage} className="text-center">
          <div style={currentImage} className="text-center">
          </div>
        </div>
      </div>
    )
  }
});
