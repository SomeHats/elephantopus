c = 1/7000

BlurXVignetteFilter = ->
  PIXI.AbstractFilter.call this
  @passes = [this]

  @uniforms = {
    blur:
      type: '1f'
      value: 1/512

    inner-radius:
      type: '1f'
      value: 0.15

    outer-radius:
      type: '1f'
      value: 0.5

    center:
      type: '2f'
      value: x: 0.5 y: 0.5
  }

  @fragment-src = [
    'precision highp float;'
    'varying vec2 vTextureCoord;'
    'varying vec4 vColor;'
    'uniform float blur;'
    'uniform float innerRadius;'
    'uniform float outerRadius;'
    'uniform vec2 center;'
    'uniform sampler2D uSampler;'

    'void main(void) {'
    ' float blurer = blur;'
    ' float gray;'
    ' float light;'
    ' float distance = length(center - vTextureCoord);'

    ' if (distance < innerRadius) {'
    '   blurer = 0.0;'
    '   gray = 0.0;'
    '   light = 0.0;'
    ' } else {'
    '   float dc = ((distance - innerRadius) / (outerRadius - innerRadius));'
    '   blurer = blur * dc;'
    '   gray = 0.7 * dc;'
    '   light = 0.3 * dc;'

    '   if (gray > 1.0) { gray = 1.0; }'
    '   if (light > 1.0) { light = 1.0; }'
    ' }'

    ' vec4 sum = vec4(0.0);'

    ' sum += texture2D(uSampler, vec2(vTextureCoord.x - 4.0*blurer, vTextureCoord.y)) * 0.05;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x - 3.0*blurer, vTextureCoord.y)) * 0.09;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x - 2.0*blurer, vTextureCoord.y)) * 0.12;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x - blurer, vTextureCoord.y)) * 0.15;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y)) * 0.16;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x + blurer, vTextureCoord.y)) * 0.15;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x + 2.0*blurer, vTextureCoord.y)) * 0.12;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x + 3.0*blurer, vTextureCoord.y)) * 0.09;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x + 4.0*blurer, vTextureCoord.y)) * 0.05;'

    ' gl_FragColor = sum;'

    ' float lightness = 0.2126*gl_FragColor.r + 0.7152*gl_FragColor.g + 0.0722*gl_FragColor.b;'
    ' vec3 target = mix(vec3(1.0/255.0, 25.0/255.0, 23.0/255.0), vec3(42.0/255.0, 66.0/255.0, 62.0/255.0), lightness);'
    ' gl_FragColor.rgb = mix(gl_FragColor.rgb, target, gray);'
    # ' gl_FragColor.rgb = mix(gl_FragColor.rgb, vec3(1.0/255.0, 25.0/255.0, 23.0/255.0), light);'
    '}'
  ]

  @

BlurXVignetteFilter.prototype = Object.create PIXI.AbstractFilter.prototype
BlurXVignetteFilter.prototype.constructor = BlurXVignetteFilter

Object.define-property BlurXVignetteFilter.prototype, 'blur', {
  get: ->
    @uniforms.blur.value / c

  set: (value) ->
    @dirty = false
    @uniforms.blur.value = value * c
}

Object.define-property BlurXVignetteFilter.prototype, 'innerRadius', {
  get: ->
    @uniforms.inner-radius.value

  set: (value) ->
    @dirty = false
    @uniforms.inner-radius.value = value
}

Object.define-property BlurXVignetteFilter.prototype, 'outerRadius', {
  get: ->
    @uniforms.outer-radius.value

  set: (value) ->
    @dirty = false
    @uniforms.outer-radius.value = value
}

Object.define-property BlurXVignetteFilter.prototype, 'centerX', {
  get: ->
    @uniforms.center.value.x

  set: (value) ->
    @dirty = false
    @uniforms.center.value.x = value
}

Object.define-property BlurXVignetteFilter.prototype, 'centerY', {
  get: ->
    @uniforms.center.value.y

  set: (value) ->
    @dirty = false
    @uniforms.center.value.y = value
}

#########################################################

BlurYVignetteFilter = ->
  PIXI.AbstractFilter.call this
  @passes = [this]

  @uniforms = {
    blur:
      type: '1f'
      value: 1/512

    inner-radius:
      type: '1f'
      value: 0.15

    outer-radius:
      type: '1f'
      value: 0.5

    center:
      type: '2f'
      value: x: 0.5 y: 0.5
  }

  @fragment-src = [
    'precision highp float;'
    'varying vec2 vTextureCoord;'
    'varying vec4 vColor;'
    'uniform float blur;'
    'uniform float innerRadius;'
    'uniform float outerRadius;'
    'uniform vec2 center;'
    'uniform sampler2D uSampler;'

    'void main(void) {'
    ' float blurer = blur;'
    ' float distance = length(center - vTextureCoord);'

    ' if (distance < innerRadius) {'
    '   blurer = 0.0;'
    ' } else {'
    '   blurer = blur * ((distance - innerRadius) / (outerRadius - innerRadius));'
    ' }'

    ' vec4 sum = vec4(0.0);'

    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y - 4.0*blurer)) * 0.05;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y - 3.0*blurer)) * 0.09;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y - 2.0*blurer)) * 0.12;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y - blurer)) * 0.15;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y)) * 0.16;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y + blurer)) * 0.15;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y + 2.0*blurer)) * 0.12;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y + 3.0*blurer)) * 0.09;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y + 4.0*blurer)) * 0.05;'

    ' gl_FragColor = sum;'
    '}'
  ]

  @

BlurYVignetteFilter.prototype = Object.create PIXI.AbstractFilter.prototype
BlurYVignetteFilter.prototype.constructor = BlurYVignetteFilter

Object.define-property BlurYVignetteFilter.prototype, 'blur', {
  get: ->
    @uniforms.blur.value / c

  set: (value) ->
    @dirty = false
    @uniforms.blur.value = value * c
}

Object.define-property BlurYVignetteFilter.prototype, 'innerRadius', {
  get: ->
    @uniforms.inner-radius.value

  set: (value) ->
    @dirty = false
    @uniforms.inner-radius.value = value
}

Object.define-property BlurYVignetteFilter.prototype, 'outerRadius', {
  get: ->
    @uniforms.outer-radius.value

  set: (value) ->
    @dirty = false
    @uniforms.outer-radius.value = value
}

Object.define-property BlurYVignetteFilter.prototype, 'centerX', {
  get: ->
    @uniforms.center.value.x

  set: (value) ->
    @dirty = false
    @uniforms.center.value.x = value
}

Object.define-property BlurYVignetteFilter.prototype, 'centerY', {
  get: ->
    @uniforms.center.value.y

  set: (value) ->
    @dirty = false
    @uniforms.center.value.y = value
}

#########################################################

window.BlurVignetteFilter = ->
  @blur-x-filter = new BlurXVignetteFilter!
  @blur-y-filter = new BlurYVignetteFilter!

  @blur-x-after = new BlurXVignetteFilter!
  @blur-y-after = new BlurYVignetteFilter!

  @passes = [ @blur-x-filter, @blur-y-filter, @blur-x-after, @blur-y-after ]

  @

Object.define-property BlurVignetteFilter.prototype, 'blur', {
  get: ->
    @blur-x-filter.blur

  set: (value) ->
    @blur-x-filter.blur = value
    @blur-y-filter.blur = value
}

Object.define-property BlurVignetteFilter.prototype, 'postBlur', {
  get: ->
    @blur-x-after.blur

  set: (value) ->
    @blur-x-after.blur = value
    @blur-y-after.blur = value
}

Object.define-property BlurVignetteFilter.prototype, 'innerRadius', {
  get: ->
    @blur-x-filter.inner-radius

  set: (value) ->
    @blur-x-filter.inner-radius = value
    @blur-y-filter.inner-radius = value
}

Object.define-property BlurVignetteFilter.prototype, 'outerRadius', {
  get: ->
    @blur-x-filter.outer-radius

  set: (value) ->
    @blur-x-filter.outer-radius = value
    @blur-y-filter.outer-radius = value
}

Object.define-property BlurVignetteFilter.prototype, 'centerX', {
  get: ->
    @blur-x-filter.center-x

  set: (value) ->
    @blur-x-filter.center-x = value
    @blur-y-filter.center-x = value
}

Object.define-property BlurVignetteFilter.prototype, 'centerY', {
  get: ->
    @blur-x-filter.center-y

  set: (value) ->
    @blur-x-filter.center-y = value
    @blur-y-filter.center-y = value
}

#########################################################
#########################################################

GlowYFilter = ->
  PIXI.AbstractFilter.call this
  @passes = [this]

  @uniforms = {
    blur:
      type: '1f'
      value: 1/512

  }

  @fragment-src = [
    'precision highp float;'
    'varying vec2 vTextureCoord;'
    'varying vec4 vColor;'
    'uniform float blur;'
    'uniform sampler2D uSampler;'

    'void main(void) {'
    ' float blurer = blur;'

    ' vec4 sum = vec4(0.0);'

    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y - 4.0*blurer)) * 0.05;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y - 3.0*blurer)) * 0.09;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y - 2.0*blurer)) * 0.12;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y - blurer)) * 0.15;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y)) * 0.16;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y + blurer)) * 0.15;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y + 2.0*blurer)) * 0.12;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y + 3.0*blurer)) * 0.09;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y + 4.0*blurer)) * 0.05;'

    ' gl_FragColor.rgb = mix(gl_FragColor.rgb, sum.rgb, 1.0);'

    '}'
  ]

  @

GlowYFilter.prototype = Object.create PIXI.AbstractFilter.prototype
GlowYFilter.prototype.constructor = GlowYFilter

Object.define-property GlowYFilter.prototype, 'blur', {
  get: ->
    @uniforms.blur.value / c

  set: (value) ->
    @dirty = false
    @uniforms.blur.value = value * c
}

#########################################################

GlowXFilter = ->
  PIXI.AbstractFilter.call this
  @passes = [this]

  @uniforms = {
    blur:
      type: '1f'
      value: 1/512

  }

  @fragment-src = [
    'precision highp float;'
    'varying vec2 vTextureCoord;'
    'varying vec4 vColor;'
    'uniform float blur;'
    'uniform sampler2D uSampler;'

    'void main(void) {'
    ' float blurer = blur;'

    ' vec4 sum = vec4(0.0);'

    ' sum += texture2D(uSampler, vec2(vTextureCoord.x - 4.0*blurer, vTextureCoord.y)) * 0.05;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x - 3.0*blurer, vTextureCoord.y)) * 0.09;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x - 2.0*blurer, vTextureCoord.y)) * 0.12;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x - blurer, vTextureCoord.y)) * 0.15;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y)) * 0.16;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x + blurer, vTextureCoord.y)) * 0.15;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x + 2.0*blurer, vTextureCoord.y)) * 0.12;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x + 3.0*blurer, vTextureCoord.y)) * 0.09;'
    ' sum += texture2D(uSampler, vec2(vTextureCoord.x + 4.0*blurer, vTextureCoord.y)) * 0.05;'

    ' gl_FragColor = sum + gl_FragColor;'

    '}'
  ]

  @

GlowXFilter.prototype = Object.create PIXI.AbstractFilter.prototype
GlowXFilter.prototype.constructor = GlowXFilter

Object.define-property GlowXFilter.prototype, 'blur', {
  get: ->
    @uniforms.blur.value / c

  set: (value) ->
    @dirty = false
    @uniforms.blur.value = value * c
}

###########################################################

window.GlowFilter = ->
  @x-filter = new GlowXFilter!
  @y-filter = new GlowYFilter!


  @passes = [ @x-filter, @y-filter ]

  @

Object.define-property GlowFilter.prototype, 'blur', {
  get: ->
    @x-filter.blur

  set: (value) ->
    @x-filter.blur = value
    @y-filter.blur = value
}

############################################################

window.BackgroundShader = BackgroundShader = ->
  PIXI.AbstractFilter.call this
  @passes = [this]

  @uniforms = {
    time:
      type: '1f'
      value: Date.now!

    position:
      type: '2f'
      value: x: 0 y: 0

  }

  @fragment-src = [
    '//'
    '// Description : Array and textureless GLSL 2D/3D/4D simplex'
    '// noise functions.'
    '// Author : Ian McEwan, Ashima Arts.'
    '// Maintainer : ijm'
    '// Lastmod : 20110822 (ijm)'
    '// License : Copyright (C) 2011 Ashima Arts. All rights reserved.'
    '// Distributed under the MIT License. See LICENSE file.'
    '// https://github.com/ashima/webgl-noise'
    '//'
    'precision highp float;'

    'vec3 mod289(vec3 x) {'
    '  return x - floor(x * (1.0 / 289.0)) * 289.0;'
    '}'

    'vec4 mod289(vec4 x) {'
    '  return x - floor(x * (1.0 / 289.0)) * 289.0;'
    '}'

    'vec4 permute(vec4 x) {'
    '     return mod289(((x*34.0)+1.0)*x);'
    '}'

    'vec4 taylorInvSqrt(vec4 r)'
    '{'
    '  return 1.79284291400159 - 0.85373472095314 * r;'
    '}'

    'float snoise(vec3 v)'
    '  {'
    '  const vec2 C = vec2(1.0/6.0, 1.0/3.0) ;'
    '  const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);'

    '// First corner'
    '  vec3 i = floor(v + dot(v, C.yyy) );'
    '  vec3 x0 = v - i + dot(i, C.xxx) ;'

    '// Other corners'
    '  vec3 g = step(x0.yzx, x0.xyz);'
    '  vec3 l = 1.0 - g;'
    '  vec3 i1 = min( g.xyz, l.zxy );'
    '  vec3 i2 = max( g.xyz, l.zxy );'

    '  // x0 = x0 - 0.0 + 0.0 * C.xxx;'
    '  // x1 = x0 - i1 + 1.0 * C.xxx;'
    '  // x2 = x0 - i2 + 2.0 * C.xxx;'
    '  // x3 = x0 - 1.0 + 3.0 * C.xxx;'
    '  vec3 x1 = x0 - i1 + C.xxx;'
    '  vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y'
    '  vec3 x3 = x0 - D.yyy; // -1.0+3.0*C.x = -0.5 = -D.y'

    '// Permutations'
    '  i = mod289(i);'
    '  vec4 p = permute( permute( permute('
    '             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))'
    '           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))'
    '           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));'

    '// Gradients: 7x7 points over a square, mapped onto an octahedron.'
    '// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)'
    '  float n_ = 0.142857142857; // 1.0/7.0'
    '  vec3 ns = n_ * D.wyz - D.xzx;'

    '  vec4 j = p - 49.0 * floor(p * ns.z * ns.z); // mod(p,7*7)'

    '  vec4 x_ = floor(j * ns.z);'
    '  vec4 y_ = floor(j - 7.0 * x_ ); // mod(j,N)'

    '  vec4 x = x_ *ns.x + ns.yyyy;'
    '  vec4 y = y_ *ns.x + ns.yyyy;'
    '  vec4 h = 1.0 - abs(x) - abs(y);'

    '  vec4 b0 = vec4( x.xy, y.xy );'
    '  vec4 b1 = vec4( x.zw, y.zw );'

    '  //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;'
    '  //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;'
    '  vec4 s0 = floor(b0)*2.0 + 1.0;'
    '  vec4 s1 = floor(b1)*2.0 + 1.0;'
    '  vec4 sh = -step(h, vec4(0.0));'

    '  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;'
    '  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;'

    '  vec3 p0 = vec3(a0.xy,h.x);'
    '  vec3 p1 = vec3(a0.zw,h.y);'
    '  vec3 p2 = vec3(a1.xy,h.z);'
    '  vec3 p3 = vec3(a1.zw,h.w);'

    '//Normalise gradients'
    '  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));'
    '  p0 *= norm.x;'
    '  p1 *= norm.y;'
    '  p2 *= norm.z;'
    '  p3 *= norm.w;'

    '// Mix final noise value'
    '  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);'
    '  m = m * m;'
    '  return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1),'
    '                                dot(p2,x2), dot(p3,x3) ) );'
    '  }'

    'varying vec2 vTextureCoord;'
    'varying vec4 vColor;'
    'uniform float time;'
    'uniform vec2 position;'
    'uniform sampler2D uSampler;'

    'void main(void)'
    '{'
    '  vec2 uv = position;'
    '  uv.y *= -1.0;'
    '  uv += gl_FragCoord.xy;'
    '  uv = uv / 200.0;'
    '  uv.y *= 0.3;'
    '  gl_FragColor = vec4(1.0);'
    '  float c = snoise(vec3(uv, time / 2.0));'
    '  gl_FragColor.rgb = mix(vec3(1.0/255.0, 25.0/255.0, 23.0/255.0), vec3(42.0/255.0, 66.0/255.0, 62.0/255.0), c);'
    '}'
  ]

  @

BackgroundShader.prototype = Object.create PIXI.AbstractFilter.prototype
BackgroundShader.prototype.constructor = BackgroundShader

Object.define-property BackgroundShader.prototype, 'time', {
  get: ->
    @uniforms.time.value / c

  set: (value) ->
    @dirty = false
    @uniforms.time.value = value * c
}

Object.define-property BackgroundShader.prototype, 'position', {
  get: ->
    @uniforms.position.value

  set: (value) ->
    @dirty = false
    @uniforms.position.value = value
}
