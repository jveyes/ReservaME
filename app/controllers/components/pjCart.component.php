<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjCart
{
	private $session = array();
	
	public function __construct(&$session)
	{
		$this->session =& $session;
		
		return $this;
	}
	
	public function clear()
	{
		$this->session = array();

		return $this;
	}
	
	public function get($key)
	{
		if ($this->has($key))
		{
			return $this->session[$key];
		}
		
		return false;
	}
	
	public function getAll()
	{
		return $this->session;
	}
	
	public function getCount()
	{
		return count($this->session);
	}
	
	public function has($key)
	{
		if (!array_key_exists($key, $this->session))
		{
			return false;
		}
		
		return true;
	}
	
	public function isEmpty()
	{
		return empty($this->session);
	}
	
	public function remove($key)
	{
		$this->session[$key] = NULL;
		unset($this->session[$key]);
		
		return $this;
	}
	
	public function update($key, $value)
	{
		$this->session[$key] = $value;
		
		if ((int) $value === 0)
		{
			$this->remove($key);
		}
		
		return $this;
	}
}
?>