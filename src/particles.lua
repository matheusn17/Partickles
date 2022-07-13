particles = {}

--particles.myParticle = {
--  myParticlesProps
--}

--Name, density and color are mandatory

particles.water = {
  name = "water",
  density = 1,
  color = {r = 0.1, g = 0.5, b = 0.8, a = 1},
  fluid = true
}

particles.rock = {
  name = "rock",
  density = 1.6,
  color = {r = 0.35, g = 0.35, b = 0.4, a = 1}
}

particles.terrain = {
  name = "terrain",
  density = 1.4,
  color = {r = 0.5, g = 0.35, b = 0.1, a = 1}
}

particles.mud = {
  name = "mud",
  density = 1.3,
  color = {r = 0.6, g = 0.45, b = 0.2, a = 1},
  fluid = true
}

particles.oil = {
  name = "oil",
  density = 0.9,
  color = {r = 0.2, g = 0.2, b = 0.25, a = 1},
  fluid = true
}


-- Absence of matter, also known as Vacuum
particles.void = {
  name = "void",
  density = 0,
  color = {r = 0, g = 0, b = 0, a = 0},
  fluid = true,
  skip = true
}

return particles
