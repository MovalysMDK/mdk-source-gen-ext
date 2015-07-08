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
package com.adeuza.movalysfwk.mf4mdd.ios.generators;

import org.dom4j.Document;

import com.a2a.adjava.languages.ios.xmodele.MIOSImportDelegate;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.generator.AbstractDataLoaderGenerator;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderCombo;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IImportDelegate;

/**
 * Dataloader generator for IOS
 *
 */
public class MF4IDataLoaderGenerator extends AbstractDataLoaderGenerator {
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.mbandroid.generator.DataLoaderGenerator#computeXmlForDataLoaderInterface(com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader)
	 */
	@Override
	protected Document computeXmlForDataLoaderInterface(
			MDataLoader p_oDataLoader) {
		Document r_xDataloader = super.computeXmlForDataLoaderInterface(p_oDataLoader);
		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		r_xDataloader.getRootElement().add(oImportDlg.toXml());
		return r_xDataloader;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.mbandroid.generator.DataLoaderGenerator#computeXmlForDataLoaderImpl(com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader)
	 */
	protected Document computeXmlForDataLoaderImpl(MDataLoader p_oDataLoader) {
		Document r_xDataloader = super.computeXmlForDataLoaderImpl(p_oDataLoader);
		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.FACTORIES.name(), p_oDataLoader.getMasterInterface().getEntity().getName() + "+Factory");
		
		for(MDataLoaderCombo oCombo : p_oDataLoader.getMasterInterface().getCombos() )
		{
			oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ENTITIES.name(), oCombo.getEntityViewModel().getEntityToUpdate().getName());
		}
		
		if ( !p_oDataLoader.getMasterInterface().getEntity().isTransient()) {
			oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.DAO.name(), p_oDataLoader.getMasterInterface().getEntity().getName() + "+Dao");
		}
		
		oImportDlg.addImport(MF4IImportDelegate.MF4IImportCategory.DATALOADER.name(), p_oDataLoader.getName());
		r_xDataloader.getRootElement().add(oImportDlg.toXml());
		return r_xDataloader;
	}
	
	/**
	 * Get filename for dataloader implementation
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @return file name for implementation
	 */
	protected String getImplFileName( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForIOSImpl("dataloader", p_oDataLoader.getName(), p_oMProject.getSourceDir());
	}
	
	/**
	 * Get filename for dataloader interface
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @return file name for interface
	 */
	protected String getInterfaceFileName( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForIOSInterface( "dataloader", p_oDataLoader.getName(), p_oMProject.getSourceDir());
	}
}
