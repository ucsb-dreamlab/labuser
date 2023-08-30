#!/bin/bash

if ! $(gum confirm --affirmative="Continue" --negative="Quit"  "DREAM Lab Login"); then
    exit
fi

if name=$(gum input --placeholder="Your Name" ); then
    if [[ -z $name ]]; then exit; fi
    echo $name
else
    exit
fi

if email=$(gum input --placeholder="Your Email"); then
    if [[ -z $email ]]; then exit; fi
    echo $email
else
    exit
fi

if [[ -z "$name" || -z "$email" ]]; then
    exit
fi

step ca certificate $email ~/.config/oxctl/labuser.crt ~/.config/oxctl/labuser.key --provisioner google-oidc --console

if [[ $? -lt 0 ]]; then
    exit
fi

oxctl config --set default_user_email $email
oxctl config --set default_user_name $name