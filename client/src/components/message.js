import React from "react";
import { Message, Icon } from "semantic-ui-react";

const MessageWait = () => (
  <Message className="helvetica w-100 ma3" icon>
    <Icon className="helvetica w-100" name="circle notched" loading />
    <Message.Content>
      <Message.Header className="helvetica w-100 b">
        Just one second!
      </Message.Header>
      Opening data and calculating hases... Please press 'Open files'.
    </Message.Content>
  </Message>
);

export default MessageWait;
