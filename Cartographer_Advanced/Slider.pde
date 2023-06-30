class slider {
  float sliderWidth;
  float sliderHeight;
  float minValue;
  float maxValue;
  float currentValue;
  float x;
  float y;
  String text;
  color handleColor;
  color hoverColor;
  color backgroundColor;
  color fillColor;
  boolean interactible;

  boolean HoveringHandle = false;

  slider(float SliderWidth, float SliderHeight, float MinValue, float MaxValue, float X, float Y, float StartValue, String Text, color HandleColor, color HoverColor, color BackgroundColor, color FillColor, boolean Interactible) {
    sliderWidth = SliderWidth;
    sliderHeight = SliderHeight;
    minValue = MinValue;
    maxValue = MaxValue;
    x = X;
    y = Y;
    currentValue = StartValue / (MaxValue / SliderWidth);
    text = Text;
    interactible = Interactible;
    handleColor = HandleColor;
    hoverColor = HoverColor;
    backgroundColor = BackgroundColor;
    fillColor = FillColor;
  }

  void Run() {
    DrawSliderRect();

    if (interactible) {
      MoveHandle();
      DrawFillRect();
      DrawHandle();
    } else {
      DrawFillRect();
    }
    
    DrawText();
  }

  void DrawSliderRect() {
    fill(backgroundColor);
    rect(x, y, sliderWidth, sliderHeight);
  }

  void DrawFillRect() {
    fill(0);
    rect(x, y, currentValue, sliderHeight);
  }

  void MoveHandle() {
    if (HoveringHandle) {
      currentValue = mouseX - x;
    }
    if (currentValue < 0) {
      currentValue = 0;
    }
    if (currentValue > sliderWidth) {
      currentValue = sliderWidth;
    }
  }

  void DrawHandle() {
    if (HoveringHandle) {
      fill(#8dfce9);
    } else {
      fill(handleColor);
    }
    ellipse(currentValue + x, y + sliderHeight / 2, sliderHeight * 2, sliderHeight * 2);
  }

  void DrawText() {
    fill(255);
    textSize(10);
    text(text, x, y - 5);
  }

  void OnClickEvent() {
    float DistanceToHandle = sqrt(((mouseX - currentValue - x) * (mouseX - currentValue - x)) + ((mouseY - y - sliderHeight / 2) * (mouseY - y - sliderHeight / 2)));
    if (DistanceToHandle < sliderHeight) {
      HoveringHandle = true;
    } else {
      HoveringHandle = false;
    }
  }
}
