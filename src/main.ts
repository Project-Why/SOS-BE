import { INestApplication, ValidationPipe } from '@nestjs/common'
import { NestFactory } from '@nestjs/core'

import { isLocal } from '@utils'

import { AppModule } from './app.module'

async function bootstrap() {
  const app: INestApplication = await NestFactory.create(AppModule)
  app.useGlobalPipes(new ValidationPipe())
  app.enableCors({
    origin: isLocal()
      ? 'http://localhost:3000'
      : 'https://Project-Why.github.io',
  })
  await app.listen(4000)
}
bootstrap()
