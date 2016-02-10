/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.xmodele;

import java.util.Collection;

import com.a2a.adjava.xmodele.IModelDictionary;

/**
 * @author lmichenaud
 *
 */
public interface MFModelDictionary extends IModelDictionary {

	/**
	 * @param p_sName
	 * @param p_oDataLoader
	 */
	public void registerDataLoader(MDataLoader p_oDataLoader );
		
	/**
	 * @return
	 */
	public Collection<MDataLoader> getAllDataLoaders();
	
	/**
	 * Return the <code>DataLoader</code> that match to the current name send as parameter.
	 * @param p_sName the name of the DataLoader
	 * @return object of type <code>MDataLoader</code>
	 */
	public MDataLoader getDataLoader(String p_sName);
}
