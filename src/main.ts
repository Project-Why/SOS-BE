import { INestApplication, Logger, ValidationPipe } from '@nestjs/common'
import { NestFactory } from '@nestjs/core'

import { isLocal } from '@utils'

import { HttpExceptionFilter } from '@middlewares/exception-filter.middleware'

import { AppModule } from './app.module'

const logger = new Logger()

async function bootstrap() {
  const app: INestApplication = await NestFactory.create(AppModule)
  app.useGlobalFilters(new HttpExceptionFilter())
  app.useGlobalPipes(new ValidationPipe())
  app.enableCors({
    origin: isLocal()
      ? 'http://localhost:3000'
      : 'https://project-why.github.io',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
  })
  await app.listen(process.env.PORT)
}

if (isNaN(parseInt(process.env.PORT))) {
  logger.error('No port provided.')
  process.exit(666)
}

bootstrap().then(() => logger.log(`Service listening: ${process.env.PORT}`))
