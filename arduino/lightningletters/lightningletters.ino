

int* word2index(String message) {
  //returns array with indexes of leds
  String matrix = "GOODXXXXMORNINGXWELCOMESSTOTTHEAVXD-SHOP";
  //config
  int rowLen = 8;
  int first_led = 0;

  int i; //first_led
  int message_i = 0; //count index in the message
  int indizes[message.length()];
  for (i=first_led; i<matrix.length(); i++) {
    if (matrix[i] == message[message_i]) {
      indizes[message_i] = i;
       }
    if (message_i == message.length()-1) {
      return indizes;
      }
    }
  return indizes;
  }




void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  int indexes* = word2index("WELCOME");
  
  Serial.println([0]);

}

void loop() {
  // put your main code here, to run repeatedly:

}
