jollaSms.sh
====

Simple command-line script to send SMS messages via a Jolla phone.
This version is an alternative to "https://github.com/ciofeca/jsms" which is based on Ruby 1.9
why not work on older versions.

Author:
- www.messaggiero.it


Example use:
- *jollaSms.sh mom have you cooked the pasta?*

Why:
- I spend a lot of time working in a Linux terminal window

Requirements:
- a Jolla phone connected to your LAN using a fixed IP address
- the phone has to be in "developer mode" with *ssh* enabled and *authorized_keys*
- a Linux box with awk installed

Configuration:

- edit *jollaSms.sh* script to verify/change the default options

  On the top of the jollaSms.sh You can change the following settings:
 * IP or DNS of jolla
  export jolladdr="jolla"
  you can change "jolla" with IP if you have not defined entry "jolla" 
  in the /etc/hosts

 * Area Code
  export areacode="+39"
  you can change "+39" with la tua area code.  

Create *$HOME/.jsms-contacts* with your *name,phone* aliases
- Example file contents: 

   mom,+399999999999	
   dad,+399999999998

Usage:
- accepts either a phone number or an alias
- Esample using alias
  *jollaSms.sh mom have you cooked the pasta?*

   is equivalent to:
   
  *jollaSms.sh +399999999999 have you cooked the pasta?*

What happens:
- sanitizes the single- and double-quotes
- executes the *ssh* call to ask the Sailfish OS *dbus* to send an SMS
- executes the *ssh* call to get the "group" of the phone stored SMS conversation
- executes the *ssh* call to update the relevant conversation

Configuration:
- In the top of the jollaSms.sh You can change the following settings:
 * IP or DNS of jolla
  export jolladdr="jolla"
  you can change "jolla" with IP if you have not defined entry "jolla" 
  in the /etc/hosts

 * Area Code
  export areacode="+39"
  you can change "+39" with your area code. 

Still missing:
- does not check for text length (thus it cannot tell you if the message requires more than one SMS)
