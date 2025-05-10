import { Hono } from 'hono';
import { cors } from 'hono/cors';
import auth from './routes/auth';

const app = new Hono<{ Bindings: CloudflareBindings }>();

app.use('*', cors());

app.get('/', (c) => {
  return c.text('Hello World!');
});

app.route('/auth', auth);

export default app;
