var WineCardTitle = React.createClass({

  // add function to handleName with if condition

  render: function() {

    // why do i need to put the function inside the render?
    var titleFontSize = function(titleName) {
      if (titleName.length > 30) {
        return titleName.slice(0, 25) + '...';
      } else {
        return titleName;
      };
    };

    return (
      <div>
        <div className="card-title">
          {titleFontSize(this.props.wine_name)}
        </div>
      </div>
    );
  }
});
