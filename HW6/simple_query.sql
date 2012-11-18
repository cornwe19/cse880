select I2.image_name
from cse880Images I1, cse880Images I2
where I1.image_name='image11.jpg' AND I1.image_name <> I2.image_name AND
ORDImageSignature.evaluateScore( I1.image_sig, I2.image_sig, 'color=0, texture=.2, shape=.7, location=.1' ) < 25;
