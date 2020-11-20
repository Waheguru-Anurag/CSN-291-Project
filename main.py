import matplotlib.pyplot as plt

from colorizers import *

class main:
    def __init__(self,img_url):
        self.img_url = img_url

    def run(self):

        # load colorizers
        colorizer_eccv16 = eccv16(pretrained=True).eval()
        colorizer_siggraph17 = siggraph17(pretrained=True).eval()

        # default size to process images is 256x256
        # grab L channel in both original ("orig") and resized ("rs") resolutions
        img = Util.load_img(self.img_url)
        (tens_l_orig, tens_l_rs) = Util.preprocess_img(img, HW=(256,256))

        # colorizer outputs 256x256 ab map
        # resize and concatenate to original L channel
        img_bw = Util.postprocess_tens(tens_l_orig, torch.cat((0*tens_l_orig,0*tens_l_orig),dim=1))
        out_img_eccv16 = Util.postprocess_tens(tens_l_orig, colorizer_eccv16(tens_l_rs))
        out_img_siggraph17 = Util.postprocess_tens(tens_l_orig, colorizer_siggraph17(tens_l_rs))

        plt.imsave('imgs_out/eccv16.jpg', out_img_eccv16)
        plt.imsave('imgs_out/siggraph17.jpg', out_img_siggraph17)
