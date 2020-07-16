import unittest
import subprocess
import os.path

from d2s import d2s

class TestScript(unittest.TestCase):

    def test_list_docker_images(self): 
        print("\n" + self._testMethodName)
        docker_list = d2s.list_docker_images()
        self.assertTrue('clearlinux/stacks-dlrs-oss' in docker_list)

    def test_tabular_images(self):
        print("\n" + self._testMethodName)
        img_dict = d2s.tabular_images()
        self.assertTrue('clearlinux/stacks-dlrs-oss' in img_dict.values())

    def test_check_singularity_version(self):
        print("\n" + self._testMethodName)
        d2s.check_singularity_version()
        self.assertTrue(True)

    def test_get_sing_image_name(self):
        print("\n" + self._testMethodName)
        sing_name = d2s.get_sing_image_name('clearlinux/stacks-dlrs-oss:latest')
        self.assertEqual(sing_name,'clearlinux_stacks-dlrs-oss_latest') 

    def test_convert_to_singularity(self):
        print("\n" + self._testMethodName)
        d2s.convert_to_singularity('clearlinux/stacks-dlrs-oss')
        self.assertTrue(os.path.exists('clearlinux_stacks-dlrs-oss'))

if __name__ == '__main__':
    subprocess.call(['docker','pull','clearlinux/stacks-dlrs-oss'])
    unittest.main()

