import React from "react";
import { Message, Icon } from "semantic-ui-react";

const MessageWait = () => (
  <Message className="helvetica w-100 ma3" icon>
    <Icon className="helvetica w-100" name="circle notched" loading />
    <Message.Content>
      <Message.Header className="helvetica w-100">
        Just one second
      </Message.Header>
      We are fetching that content for you.
    </Message.Content>
  </Message>
);

export default MessageWait;
