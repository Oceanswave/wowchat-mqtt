package wowchat.mqtt

import com.typesafe.scalalogging.StrictLogging
import wowchat.common.CommonConnectionCallback
import wowchat.game.GamePackets

class Mqtt(mqttConnectionCallback: CommonConnectionCallback) extends GamePackets
  with StrictLogging {

}
