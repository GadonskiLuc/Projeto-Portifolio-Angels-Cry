switch (moveType) {
    
    case "circle":
        dir += rotSpd;

        var _targetX = xstart + lengthdir_x(radius, dir);
        var _targetY = ystart + lengthdir_y(radius, dir);

        xspd = _targetX - x;
        yspd = _targetY - y;

        x = _targetX;
        y = _targetY;
    break;
    
    case "horizontal":
        x = xstart + sin(current_time * 0.001 * moveSpeed) * moveDist;
        xspd = x - xprevious;
        yspd = 0;
    break;
    
    case "vertical":
        y = ystart + sin(current_time * 0.001 * moveSpeed) * moveDist;
        yspd = y - yprevious;
        xspd = 0;
    break;
}
