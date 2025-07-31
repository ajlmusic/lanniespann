// app.js
const express = require('express');
const {buildSchema} = require('graphql');
const graphqlHTTP = require('express-graphql');

const schema = buildSchema(`
type  Query {
    hello: String
}

`);
const helloResolver = function() {
    return 'Hello world!';
}

const root = {
    hello: helloResolver
}

const app = express();
app.use('/graphql', graphqlHTTP({
    schema: schema,
    rootValue: root,
    graphiql: true
}))
app.listen(4000, function() {
    console.log('GraphQL server running on http://localhost:4000/graphql');
})