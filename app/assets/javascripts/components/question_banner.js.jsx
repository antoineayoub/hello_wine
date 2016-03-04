var QuestionBanner = React.createClass({
  render: function() {
    var imgStyle = {
      height: '30vh',
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      backgroundImage: "linear-gradient(to bottom, rgba(82, 82, 82, 0.49) , rgba(61, 114, 180, 0.35)), url("+this.props.question.pic_url+")",
      // not working
      transition: 'background-image 0.5s ease'
    };
    return (
      <div>
        <div id="back-picture" style={imgStyle} class="text-center color-background">
        </div>
      </div>
    )
  }
});
