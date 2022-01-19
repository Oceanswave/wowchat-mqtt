WoWChat MQTT -- README
=================

WoWChat MQTT is a MQTT chat shim for old versions of World of Warcraft that publishes chat messages in WoW to a MQTT broker.

**It does NOT support WoW Classic or Retail servers.**

Currently supported versions are:
  * Vanilla
  * The Burning Crusade
  * Wrath of the Lich King
  * Cataclysm (4.3.4 build 15595)
  * Mists of Pandaria (5.4.8 build 18414)

Features:
* Clientless (Does not need the WoW Client to be open to run)
* Seamless Chat integration between WoW and a MQTT broker
* Subscriptions:
  * Check who is online in your guild
  * Query other players in the world
* Designed to run in a containerized environment

## How it works
The shim logs into a MQTT server. It then uses supplied information
to login as a WoW character onto your chosen server. Once it logs in to WoW as a character,
and sees the configured channels. It will publish MQTT messages and WoW chat respectively.

##### DO NOT, under any circumstances, use this bot on an account with existing characters!
Even though this bot does not do anything malicious, some servers may not like a bot connecting, and GMs may ban the account!

##### Watching GD's WotLK chat:
![gd-echoes](https://raw.githubusercontent.com/fjaros/wowchat/master/images/example1.png)

##### Talking in Guild Chat:
![guild-chat-construct](https://raw.githubusercontent.com/fjaros/wowchat/master/images/example2.png)

## Setup & Prerequisites

1. First you will want to create a MQTT Broker - we recommend [emqx](https://www.emqx.io/)
2. Configure WoW Chat by opening `wowchat.conf` in a text editor.
   * You can also create your own file, using the supplied `wowchat.conf` as a template.
   * In section **mqtt**:
     * **server**: Enter in the address of the MQTT broker.
   * In section **wow**:
     * **platform**: Leave as **Mac** unless your target server has Warden (anticheat) disabled AND it is blocking/has disabled Mac logins. In this case put **Windows**.
     * **locale**: Optionally specify a locale if you want to join locale-specific global channels. **enUS** is the default locale.
     * **enable_server_motd**: **0** to ignore sending server's MotD. **1** to send server's MotD as a SYSTEM message.
     * **version**: put either 1.12.1, 2.4.3, 3.3.5, 4.3.4, or 5.4.8 based on the server's expansion.
     * **build**: you can include a build=<build number> setting in the config, if you are using a custom build version on your server.
     * **realmlist**: this is server's realmlist, same as in your realmlist.wtf file.
     Example values are logon.lightshope.org or wow.gamer-district.org
     * **realm**: This is the realm name the Bot will connect to.
     It is the Text shown on top of character list window. Put ONLY the name, do NOT put the realm type like PVP or PVE.
     In the following example, the **realm** value is The Construct
     * ![realm-construct](https://raw.githubusercontent.com/fjaros/wowchat/master/images/example3.png)
     * **account**: The bot's WoW game account, or set the WOW_ACCOUNT environment variable.
     * **password**: The bot's WoW game account password, or set the WOW_PASSWORD environment variable.
     * **character**: Your character's name as would be shown in the character list, or set the WOW_CHARACTER environment variable.
   * In section **guild**:
     * This section sets up guild notifications.
     * For each notification, **online**, **offline**, **joined**, **left**, **motd**, **achievement** specify:
       * **enabled**: **0** to not publish to MQTT, **1** to publish to MQTT
       * **format**: How to display the message.
       * **topic**: Optional topic where to display message instead of the default guild topic.
   * In section **chat**:
     * This section sets up the channel relays between MQTT and WoW. You can have an unlimited number of channel relays.
     * **direction**: How do you want to relay each channel, put either
     **wow_to_mqtt**, **mqtt_to_wow**, or **both**.
     * **wow** section:
       * In type put one of, **Say**, **Guild**, **Officer**, **Emote**, **Yell**, **System**, **Whisper**, **Channel**. This is the type of chat the Bot will read for this section.
         * If you put **type=Channel**, you also must provide a **channel=name of channel** value.
       * In format put how you want to display the message, supported replacable values are **%time**, **%user**, **%message**, and **%channel** if above type is **Channel**.
       * **filters**: See filters section. If a channel configuration has this section, it will override the global filters and use these instead for this channel.
         * If this is in the **wow** section, it will filter MQTT->WoW messages.
     * **mqtt** section:
       * **format**: Same options as in **wow** section above.
       * **filters**: See filters section. If a channel configuration has this section, it will override the global filters and use these instead for this channel.
         * If this is in the **MQTT** section, it will filter WoW->MQTT messages.
   * In section **filters**:
     * This section specifies filters for chat messages to be ignored by the bot. It works for both directions, MQTT to WoW and WoW to MQTT. It can be overriden in each specific channel configuration as stated above.
     * **enabled**: **0** to globally disable all filters, **1** to enable them.
     * **patterns**: List of Java Regex match patterns. If the incoming messages matches any one of the patterns and filters are enabled, it will be ignored.
       * When ignored, the message will not be relayed; however it will be logged into the bot's command line output prepended with the word FILTERED.

## Run
1. Download the latest ready-made binary from github releases: https://github.com/fjaros/wowchat/releases
   * **Make sure you have a Java Runtime Environment (JRE) 1.8 or higher installed on your system!**
   * **On Windows**: Edit wowchat.conf as above and run `run.bat`
   * **On Mac/Linux**: Edit wowchat.conf as above and run `run.sh`

OR to compile yourself:
1. WoW Chat is written in Scala and compiles to a Java executable using [maven](https://maven.apache.org).
2. It uses Java JDK 1.8 and Scala 2.12.12.
3. Run `mvn clean package` which will produce a file in the target folder called `wowchat-mqtt-1.3.7.zip`
4. unzip `wowchat-mqtt-1.3.7.zip`, edit the configuration file and run `java -jar wowchat-mqtt.jar <config file>`
   * If no config file is supplied, the bot will try to use `wowchat.conf`
