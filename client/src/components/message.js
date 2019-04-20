import React from "react";
import { Message, Icon, Button } from "semantic-ui-react";

export const ButtonExampleLoading = (text, onclick) => (
  <Button onClick={() => onclick()} floating="right" loading>
    {text}
  </Button>
);

export const MessageWait = (title, message) => (
  <Message icon>
    <Icon name="circle notched" loading />
    <Message.Content className="ma1">
      <Message.Header className="helvetica w-100 b">{title}</Message.Header>
      {message}
    </Message.Content>
  </Message>
);
