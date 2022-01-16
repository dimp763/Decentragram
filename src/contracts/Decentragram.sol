pragma solidity ^0.5.0;

contract Decentragram {
   
   string public name = "Decentragram" ;
 
    //store images (database) 
     uint public imageCount = 0;
     mapping(uint=>Image) public images;

     struct Image {
        uint id;
        string hash;
        string description;
        uint tipAmount;
        address payable author;
      } 

      event ImageCreated(
        uint id,
        string hash,
        string description,
        uint tipAmount,
        address payable author
        );

       event ImageTipped(
        uint id,
        string hash,
        string description,
        uint tipAmount,
        address payable author
        );
     
     //create images
         function uploadImage(string memory _imgHash, string memory _description) public {
         	  //make sure image hash exists
              require(bytes(_imgHash).length > 0);
              //make sure image description exists
              require(bytes(_description).length > 0 );
              //make sure uploader exists
              require(msg.sender != address(0));
              //increment image id
              imageCount ++ ;
        	  //add image to contract
              images[imageCount] = Image(imageCount, _imgHash,_description,0 ,msg.sender);
             //trigger an event

             emit ImageCreated(imageCount, _imgHash,_description,0,msg.sender);
        }

        //dose crypto ston uploader
        function tipImageOwner(uint _id) public payable {
             //make sure id exists
         	 require(_id > 0 && _id<= imageCount);
             //fetch image
             Image memory _image = images[_id];
              //fetch author
             address payable _author = _image.author;
             //pay author
             address(_author).transfer(msg.value);
             //increment the tip amount
             _image.tipAmount= _image.tipAmount + msg.value;
              //update the image 
              images[_id] = _image;
               //trigger an event
              emit ImageTipped(_id, _image.hash,_image.description,_image.tipAmount,_author);
        }

}